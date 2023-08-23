options("openxlsx.dateFormat" = "mm/dd/yyyy")
library(shinyjs)
library(shinyWidgets)
library(DT)

# prevent from overwriting files and index the file name
generate_unique_filename <- function(base_filename, extension) {
  full_path <- file.path(paste0(base_filename, extension))
  counter <- 1
  while(file.exists(full_path)) {
    full_path <- file.path(paste0(base_filename, "_", counter, extension, sep = ''))
    counter <- counter + 1
  }
  return(full_path)
}

# Check if datasets exists, and create default choice if not
data_source_choices <- if (exists("datasets")) {
  setNames(names(datasets), names(datasets))
} else {
  "No datasets available"
}

# Create a placeholder for the data variable if it doesn't exist
if (!exists("data")) {
  data <- data.frame()
}

ui <- fluidPage(
  useShinyjs(),
  titlePanel("BrANCH DATA DOWNLOADER"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Dataset Selection"),
      
      selectInput(inputId = "data_source", label = "Select Data Source",
                  choices = data_source_choices,
                  selected = if (is.character(data_source_choices)) NULL else "BrANCH_dataset"),
      
      div(
        style = "display: inline-block", actionButton("upload_data_btn", "Upload Data")
      ),
      div(
        style = "display: inline-block;", actionButton("trigger_rename", "Rename")
      ),
      uiOutput("upload_ui_elements"),
      uiOutput("rename_ui"),
      
      
      hr(),
      
      wellPanel(
        h3("Column Selection"),
        selectInput(inputId = "variable", label = "Select Column by Instrument", multiple = TRUE, choices = NULL),
        pickerInput(inputId = "variable_full", label = "Select Column by Name", multiple = TRUE, choices = NULL,
                    options = list(`plugins` = list(`remove_button` = TRUE))),
        fileInput("upload_selections", "Upload Column Selections (.CSV)"),
        actionButton("select_all_vars", "Select All"),
        actionButton("clear_all", "Clear All")
      ),
      
      hr(),
      
      wellPanel(
        h3("Export Options"),
        selectInput(inputId = "format", label = "Select format",
                    choices = c("csv", "xlsx"), selected = "csv"),
        downloadButton("downloadData", "Download"),
        downloadButton("exportSelectedColumns", "Export Selected Columns")
      )
    ),
    
    mainPanel(
      DTOutput(outputId = "table"),
      actionButton("fetch_data", "Show Data"),
      actionButton("hide_data", "Hide Data")
    )
  )
)





server <- function(input, output, session) {
  show_dataset_name_field <- reactiveVal(FALSE)
  rename_ui_visible <- reactiveVal(FALSE)
  data_uploaded <- reactiveVal(FALSE)
  upload_ui_visible <- reactiveVal(FALSE)
  
  output$rename_ui <- renderUI({
    if(rename_ui_visible()) {
      tagList(
        textInput("new_dataset_name", "New Name:"),
        actionButton("confirm_rename", "Confirm")
      )
    }
  })
  
  observeEvent(input$confirm_rename, {
    old_name <- input$data_source
    new_name <- input$new_dataset_name
    
    if(new_name %in% names(datasets())) {
      showNotification("Name already exists! Choose a different name.", type = "error")
      return(NULL)
    }
    
    # Rename in the datasets reactive list
    datasets_list <- datasets()
    datasets_list[[new_name]] <- datasets_list[[old_name]]
    datasets_list[[old_name]] <- NULL
    
    datasets(datasets_list)
    
    # Update the dropdown to reflect the change
    updateSelectInput(session, "data_source", 
                      choices = setNames(names(datasets_list), names(datasets_list)), 
                      selected = new_name)
    
    rename_ui_visible(FALSE)  # Hide the renaming UI after successful rename
  })
  
  assign_dataset_name <- function(dataset_name_input) {
      return(paste0("uploaded_", as.character(Sys.Date())))
    }
  
  observe({
    # Check if the current value of input$data_source is "No datasets available"
    if (input$data_source == "No datasets available") {
      shinyjs::hide("trigger_rename")
    } else {
      shinyjs::show("trigger_rename")
    }
  })
  
  
  output$upload_ui_elements <- renderUI({
    if (input$upload_data_btn %% 2 == 1) {
      tagList(
        fileInput('dataset_upload', 'Choose CSV or RDS File', accept = c(".csv", ".rds")),
        tags$br(),  # Add line break
        helpText("File Requirements:",
                 tags$ul(
                   tags$li("Required columns: PIDN, UnQID, DCDate, and age_at_DCDate."),
                   tags$li("Any additional columns: 'column.instrument'."),
                   tags$li("CSV: datasets should follow the format above."),
                   tags$li("RDS: contains a list of datasets with the structure above.")
                 )
        )
      )
    }
  })
  
  
  # Initialize the datasets if not already existing
  initial_datasets <- # Check in the Shiny server's environment
    if (exists("datasets", inherits = TRUE)) {
      initial_datasets <- datasets
    } else {
      # If not found, check in the global environment
      initial_datasets <- if (exists("datasets", inherits = TRUE, where = globalenv())) datasets else list()
    }
  
  datasets <- reactiveVal(initial_datasets)
  
  # Define a reactive value for data.
  data <- reactiveVal(NULL)
  

  observeEvent(input$dataset_upload, {
    req(input$dataset_upload$datapath)
    
    # Temporarily get the current datasets list
    current_datasets <- datasets()
    
    if (tools::file_ext(input$dataset_upload$datapath) == "rds") {
      new_data <- readRDS(input$dataset_upload$datapath)
      
      # Check if it's a single dataframe or a list
      if (is.data.frame(new_data)) {
        dataset_name <- assign_dataset_name(input$dataset_name)
        current_datasets[[dataset_name]] <- new_data
        print(paste("Added dataset:", dataset_name))  # Debugging print statement
      } else if (is.list(new_data)) {
        for (i in names(new_data)) {
          dataset_name <- paste0("uploaded_", i, "_", as.character(Sys.Date()))
          current_datasets[[dataset_name]] <- new_data[[i]]
          print(paste("Added dataset:", dataset_name))  # Debugging print statement
        }
      }
    } else { 
      # Assuming it's a CSV
      new_data <- read.csv(input$dataset_upload$datapath, stringsAsFactors = FALSE)
      dataset_name <- assign_dataset_name(input$dataset_name)
      current_datasets[[dataset_name]] <- new_data
      print(paste("Added dataset:", dataset_name))  # Debugging print statement
    }
    
    # Update the reactive datasets list
    datasets(current_datasets)
    print("Updated datasets reactive value")  # Debugging print statement
    
    # Signal that new data has been uploaded
    data_uploaded(TRUE)
    
    # Clear the dataset name input to avoid reusing the same name unintentionally
    updateTextInput(session, "dataset_name", value = "")
    
    # After handling the uploaded data, hide the upload button
    shinyjs::click("upload_data_btn")
  })
  
  observeEvent(data_uploaded(), {
    if(data_uploaded()) {
      print("Trying to update dropdown...")  # Debugging print statement
      
      current_datasets <- datasets()
      updateSelectInput(session, "data_source", 
                        choices = setNames(names(current_datasets), names(current_datasets)), 
                        selected = NULL)
      
      print("Dropdown updated!")  # Debugging print statement
      
      
      # Reset the signal to avoid re-triggering
      data_uploaded(FALSE)
      
    }
  })
  
# Function to update the column selections based on current data
update_column_choices <- function(current_data) {
  # Update the column choices
  updateSelectInput(session, "variable", choices = c("", setdiff(unique(sub(".*\\.", "", colnames(current_data)[grep("\\.", colnames(current_data))])), c("PIDN", "UnQID", "DCDate", "age_at_DCDate"))))
  updatePickerInput(session, "variable_full", choices = c("", setdiff(colnames(current_data), c("PIDN", "UnQID", "DCDate", "age_at_DCDate"))), selected = colnames(current_data)[1])
}

observeEvent(input$data_source, {
  # Use req to ensure that the dataset exists and is not null
  req(datasets()[[input$data_source]])
  
  # Extract and ungroup the data
  current_data <- datasets()[[input$data_source]] %>% dplyr::ungroup()
  data(current_data)
  
  # Update column choices
  update_column_choices(current_data)
})
  
  # Function to clear the rename UI
  clear_rename_ui <- function() {
    output$rename_ui <- renderUI({ NULL })
    rename_ui_visible(FALSE)
  }
  
  # Dynamic UI for Rename button
  output$rename_button_ui <- renderUI({
    if (!is.null(input$data_source) && input$data_source != "No datasets available") {
      actionButton("trigger_rename", "Rename")
    }
  })
  
  observeEvent(input$trigger_rename, {
    if (rename_ui_visible()) {
      clear_rename_ui()
    } else {
      output$rename_ui <- renderUI({
        tagList(
          textInput("dataset_name", label = "New Dataset Name", value = ""),
          actionButton("rename_dataset", "Confirm Rename")
        )
      })
      rename_ui_visible(TRUE)
    }
  })
  
  observeEvent(input$rename_dataset, {
    req(input$data_source, input$dataset_name)
    
    current_datasets <- datasets()
    
    if (is.null(current_datasets) || length(current_datasets) == 0) {
      showNotification("Error accessing datasets!", type = "error")
      return()
    }
    
    # Validate dataset name and if it exists
    if (!input$data_source %in% names(current_datasets)) {
      showNotification("Selected dataset not found!", type = "error")
      return()
    }
    
    # Check for existing dataset name
    if (input$dataset_name %in% names(current_datasets)) {
      showNotification("This dataset name already exists! Choose a different name.", type = "error")
      return()
    }
    
    # Rename the dataset
    current_datasets <- setNames(current_datasets, 
                                 ifelse(names(current_datasets) == input$data_source, 
                                        input$dataset_name, 
                                        names(current_datasets)))
    datasets(current_datasets)
    
    updateSelectInput(session, "data_source", 
                      choices = setNames(names(current_datasets), names(current_datasets)), 
                      selected = input$dataset_name)
    
    showNotification("Dataset renamed successfully!")
    clear_rename_ui()
  })
  
  data_cache <- reactiveVal()
  
  observeEvent(input$data_source, {
    current_data <- data()
    if (is.null(current_data)) {
      showNotification("Error accessing data for the selected dataset!", type = "error")
      return()
    }
    data_cache(current_data)
  })
  
  
  # Check if a file has been uploaded
  has_selections_file <- reactive({ is.null(input$upload_selections) == FALSE })
  
  # If a file has been uploaded, use it to get selections
  selections <- reactive({
    if (has_selections_file() == TRUE) {
      read.csv(input$upload_selections$datapath, header = TRUE, stringsAsFactors = FALSE)[[1]]
    } else {
      return(NULL)
    }
  })
  
  observeEvent(selections(), {
    if (!is.null(selections())) {
      all_colnames <- colnames(data_cache())
      
      instrument_to_colnames <- function(selection) {
        if (grepl("\\..+", selection)) {
          # If the selection has a dot followed by characters, it's a column name
          return(selection)
        } else {
          # Otherwise, assume it's an instrument name
          return(grep(paste0("\\.", selection), all_colnames, value = TRUE))
        }
      }
      
      selected_columns <- unique(unlist(sapply(selections(), instrument_to_colnames)))
      
      # Update column selectors with the columns that match the uploaded names
      updateSelectInput(session, "variable", selected = intersect(unique(sub("\\..+", "", selected_columns)), colnames(data_cache())))
      updateSelectInput(session, "variable_full", selected = intersect(selected_columns, colnames(data_cache())))
    }
  })
  
  selected_data <- reactive({
    default_cols <- c("PIDN", "UnQID", "DCDate", "age_at_DCDate")
    
    # Identify which default columns are present in data_cache
    existing_default_cols <- intersect(default_cols, colnames(data_cache()))
    
    # If no default columns are present, it returns just the data_cache without subsetting
    if (length(existing_default_cols) == 0) {
      return(data_cache())
    }
    
    if (length(input$variable) == 0 && length(input$variable_full) == 0) {
      return(data_cache()[, existing_default_cols, drop = FALSE])
    }
    
    suffix_vars <- data_cache()[, grep(paste0(".+\\.(?:", paste(input$variable, collapse = "|"), ")$"), colnames(data_cache())), drop = FALSE]
    
    full_name_vars <- data_cache()[, intersect(input$variable_full, colnames(data_cache())), drop = FALSE]
    
    # Remove the common columns selected in both input$variable and input$variable_full
    common_cols <- intersect(colnames(suffix_vars), input$variable_full)
    suffix_vars <- suffix_vars[, !colnames(suffix_vars) %in% common_cols, drop = FALSE]
    
    # If there is no selection in input$variable, only add columns from input$variable_full
    if (length(input$variable) == 0) {
      selected_vars <- cbind(data_cache()[, existing_default_cols, drop = FALSE], full_name_vars)
    } else {
      selected_vars <- cbind(data_cache()[, existing_default_cols, drop = FALSE], suffix_vars, full_name_vars)
    }
    selected_vars
  })
  
  # Render the table based on the reactive subset
  observeEvent(input$fetch_data, {
    output$table <- renderDT({
      datatable(selected_data(), rownames = FALSE)
    }, server = TRUE)
  })
  
  
  #hide all the data
  observeEvent(input$hide_data, {
    output$table <- renderDT(NULL)
  })
  
  
  create_custom_workbook <- function(selected_data) {
    library(openxlsx)
    wb <- createWorkbook()
    
    # Extract unique suffixes from column names with a dot
    suffixes <- unique(sub(".*\\.", "", colnames(selected_data)[grep("\\.", colnames(selected_data))]))
    
    # Extract default columns that exist
    desired_default_cols <- c("PIDN", "UnQID", "DCDate", "age_at_DCDate")
    existing_default_cols <- intersect(desired_default_cols, colnames(selected_data))
    default_cols <- selected_data[, existing_default_cols, drop = FALSE]
    
    for (suffix in suffixes) {
      sheet_name <- substr(suffix, 1, 30)
      
      # Bind default columns with suffix-specific columns
      sheet_data <- cbind(default_cols, selected_data[, grep(paste0("\\.", suffix, "$"), colnames(selected_data)), drop = FALSE])
      
      # Rename the columns
      new_names <- sub(paste0("(?<!^)\\.", suffix, "\\b"), "", colnames(sheet_data), perl = TRUE)
      dc_cols <- grep("^DCDate", new_names)
      if (length(dc_cols) > 1) {
        new_names[dc_cols[2]] <- paste0(new_names[dc_cols[2]], ".", suffix)
      }
      colnames(sheet_data) <- new_names
      
      # Format date columns
      dc_cols <- grep("^DCDate", colnames(sheet_data))
      for (i in dc_cols) {
        if(class(sheet_data[, i]) == "Date") {
          sheet_data[, i] <- format(sheet_data[, i], "%m/%d/%Y")
        }
      }
      
      # Add the worksheet and write the data
      addWorksheet(wb, sheet_name)
      writeData(wb, sheet_name, sheet_data)
    }
    
    return(wb)
  }
  
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$data_source, "_", lubridate::today(), if (input$format == "csv") ".csv" else ".xlsx", sep = "")
    },
    content = function(file) {
      if (input$format == "csv") {
        #base_filename <- paste(input$data_source, "_", lubridate::today())
        #temp_file_path <- generate_unique_filename(output_dir_datasets, base_filename, ".csv")
        write.csv(selected_data(), file, na = '', row.names = FALSE)
        #file.copy(temp_file_path, file)
      } else {
        wb <- create_custom_workbook(selected_data())
        #base_filename_xlsx <- paste(input$data_source, "_", lubridate::today())
        #temp_file_path_xlsx <- generate_unique_filename(output_dir_datasets, base_filename_xlsx, ".xlsx")
        saveWorkbook(wb, file)
        #file.copy(temp_file_path_xlsx, file)
      }
    }
  )
  
  output$exportSelectedColumns <- downloadHandler(
    filename = function() {
      paste("selected_columns_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      selected_cols <- c(input$variable, input$variable_full)
      
      # Generate unique filename in your desired directory
      base_filename <- paste("selected_columns_", Sys.Date())
      #temp_file_path <- generate_unique_filename(output_dir_columns, base_filename, ".csv")
      write.csv(data.frame(column_names = selected_cols), file, row.names = FALSE)
      
      # Now copy from the above location to the `file` location which Shiny uses for downloads
      #file.copy(temp_file_path, file)
    }
  )
  
  # Select all variables
  observeEvent(input$select_all_vars, {
    updateSelectInput(session, "variable", selected = unique(gsub(".*\\.", "", colnames(data()))))
  })
  
  # Clear selected variables and show default columns
  observeEvent(input$clear_all, {
    output$table <- renderDT(NULL)
    updateSelectInput(session, "variable", selected = character(0))
    updateSelectInput(session, "variable_full", selected = character(0))
  })
  
  # Disconnect from the database when the session ends
  onSessionEnded(function() {
    stopApp()
  })
}

shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
# 
# runApp(app)


