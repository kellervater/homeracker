#Fusion360API Python Script
#Description: Exports Core components. Connectors identified by naming convention.
#             - "Support" body (parametric by 'support_units')
#             - "Lock Pin" body (single export)
#             - "Connector" bodies (categorized by name, exported to subfolders)
#Version: 1.4.1 - Added 'pr' suffix for PullThrough connectors.

import adsk.core, adsk.fusion, adsk.cam, traceback, os
import re # Import regular expression module

def run(context):
    ui = None
    try:
        # --- Basic Fusion 360 setup ---
        app = adsk.core.Application.get()
        ui = app.userInterface
        # Using Design.cast for robustness
        design = adsk.fusion.Design.cast(app.activeProduct)
        if not design:
            if ui: ui.messageBox('No active Fusion 360 design (or product is not a Design). Aborting script.', 'Export Script Error')
            return
        
        rootComp = design.rootComponent
        doc = app.activeDocument 
        if not rootComp or not doc:
            if ui: ui.messageBox('Could not retrieve root component or active document. Aborting script.', 'Export Script Error')
            return

        # --- Get Document Version (Simplified) ---
        version_str = "v_unknown"
        try:
            if doc.dataFile:
                version_number = doc.dataFile.versionNumber
                version_str = f"v{version_number}" if version_number is not None else "v_no_version_num"
                if version_number is None and ui: ui.messageBox(f"Cloud-saved, but version unavailable. Using '{version_str}'.", "Version Warning")
            else:
                version_str = "v_local_unversioned"
                if ui: ui.messageBox(f"Document not cloud-saved. Using suffix '{version_str}'.", "Unsaved Document Info")
        except Exception as e_ver:
            version_str = "v_version_error"
            if ui: ui.messageBox(f"Version retrieval error: {e_ver}\nUsing '{version_str}'.", "Version Retrieval Error")
        # --- End Get Document Version ---

        # --- Configuration ---
        support_param_name = "support_units"
        min_support_units, max_support_units = 2, 25
        support_body_name = "Support"    # Exact name of the Support BRepBody
        lock_pin_body_name = "Lock Pin"  # Exact name of the Lock Pin BRepBody
        base_export_name_prefix = "Core" # Prefix for Support and LockPin files
        connectors_output_base_folder_name = "Connectors" # Main output folder for all connector types
        
        # Regex for connector names: extracts dimensions, optional ways, and optional type suffix
        # Pattern: e.g., "3d", "2d4w", "3d5wp", "3d4wpr", "3d4wps", "1d2wf"
        # Groups: 1=(\d+ dimensions), 2=(\d+ ways, optional), 3=(p|ps|pr|f suffix, optional)
        connector_name_pattern = re.compile(r"^(\d+)d(?:(\d+)w)?(p|ps|pr|f)?$") # Updated for 'pr'
        # --- End Configuration ---

        userParams = design.userParameters
        if userParams is None:
            if ui: ui.messageBox('Could not access user parameters. Aborting.', 'Export Script Error')
            return

        support_param = userParams.itemByName(support_param_name)
        support_body_object_for_parametric_export = rootComp.bRepBodies.itemByName(support_body_name)
        lock_pin_body_object_for_export = rootComp.bRepBodies.itemByName(lock_pin_body_name)
        
        all_export_tasks = []

        # 1. Support Tasks
        if support_body_object_for_parametric_export and support_body_object_for_parametric_export.isValid and \
           support_param and support_param.isValid:
            for i in range(min_support_units, max_support_units + 1):
                all_export_tasks.append({
                    "type": "support", "units": i, "body_object": support_body_object_for_parametric_export,
                    "base_filename": f"{base_export_name_prefix}_{support_body_name}_x{i}"})
        else: 
            missing_s_info = []
            if not (support_body_object_for_parametric_export and support_body_object_for_parametric_export.isValid):
                missing_s_info.append(f"Body '{support_body_name}'")
            if not (support_param and support_param.isValid):
                missing_s_info.append(f"Parameter '{support_param_name}'")
            if missing_s_info and ui:
                ui.messageBox(f"Support Export Warning: {', '.join(missing_s_info)} not found/valid. Skipping Support exports.", "Config Warning")

        # 2. Lock Pin Task
        if lock_pin_body_object_for_export and lock_pin_body_object_for_export.isValid:
            all_export_tasks.append({
                "type": "lock_pin", "body_object": lock_pin_body_object_for_export,
                "base_filename": f"{base_export_name_prefix}_{lock_pin_body_name}"})
        elif lock_pin_body_name and ui: 
            ui.messageBox(f"Lock Pin Export Warning: Body '{lock_pin_body_name}' not found/valid. Skipping Lock Pin export.", "Config Warning")

        # 3. Connector Tasks (by Name Parsing)
        connector_tasks_temp = []
        found_connectors_by_name = 0
        if rootComp.bRepBodies:
            for body_iter in rootComp.bRepBodies:
                if not body_iter.isValid or not body_iter.name:
                    continue
                body_name_iter = body_iter.name

                if body_name_iter == support_body_name or body_name_iter == lock_pin_body_name:
                    continue

                match = connector_name_pattern.match(body_name_iter)
                if match:
                    type_suffix = match.group(3) 

                    target_subfolder_name = None
                    if type_suffix == "p" or type_suffix == "ps" or type_suffix == "pr": # Added 'pr'
                        target_subfolder_name = "PullThrough"
                    elif type_suffix == "f":
                        target_subfolder_name = "Feet"
                    elif type_suffix is None: 
                        target_subfolder_name = "Standard"
                    
                    if target_subfolder_name:
                        found_connectors_by_name += 1
                        connector_tasks_temp.append({
                            "type": "connector",
                            "body_object": body_iter,
                            "relative_export_path_dir": os.path.join(connectors_output_base_folder_name, target_subfolder_name),
                            "base_filename": body_name_iter 
                        })
            
            if connector_tasks_temp:
                all_export_tasks.extend(connector_tasks_temp)
            
            if found_connectors_by_name == 0 and ui:
                ui.messageBox("Connector Export Warning: No bodies matching the defined connector naming patterns were found in the root component.", "Name Matching Warning")

        if not all_export_tasks:
            if ui: ui.messageBox("No export tasks were generated (possibly due to configuration or missing items). Aborting.", "Export Script Error")
            return

        folderDialog = ui.createFolderDialog()
        folderDialog.title = "Select Folder to Save STEP Files"
        dialogResult = folderDialog.showDialog()
        if dialogResult == adsk.core.DialogResults.DialogOK: exportFolder = folderDialog.folder
        else:
            if ui: ui.messageBox('Export cancelled by user. Aborting script.')
            return

        exportMgr = design.exportManager
        total_exports = len(all_export_tasks)
        progressDialog = ui.createProgressDialog()
        progressDialog.isCancelEnabled = False
        progressDialog.show(f'Exporting {base_export_name_prefix} Items', 'Initializing...', 0, total_exports)
        
        exported_count = 0
        all_root_bodies_for_visibility_ctrl = [b for b in rootComp.bRepBodies if b.isValid] if rootComp.bRepBodies else []

        if not all_root_bodies_for_visibility_ctrl and total_exports > 0 and ui:
             ui.messageBox(f"Warning: No bodies retrieved from root for visibility control, but {total_exports} tasks are planned. Exports may fail or include unintended geometry.", "Visibility Control Warning")

        for i, task in enumerate(all_export_tasks):
            try:
                target_body_for_export = task.get("body_object")
                if not target_body_for_export or not target_body_for_export.isValid:
                    progressDialog.message = f'Skipping invalid task {i+1}/{total_exports}'
                    adsk.doEvents(); continue

                progressDialog.progressValue = exported_count
                task_desc = task["base_filename"]
                if task["type"] == "support": task_desc += f" (Units: {task['units']})"
                progressDialog.message = f'Exporting: {task_desc} ({exported_count + 1}/{total_exports})'
                adsk.doEvents()

                for body_in_root_list in all_root_bodies_for_visibility_ctrl:
                    body_in_root_list.isLightBulbOn = (body_in_root_list.entityToken == target_body_for_export.entityToken)
                adsk.doEvents()

                if task["type"] == "support":
                    if support_param and support_param.isValid:
                        support_param.expression = str(task["units"])
                        adsk.doEvents()
                    else:
                        if ui: ui.messageBox(f"Support parameter '{support_param_name}' became invalid during export. Skipping support task for {target_body_for_export.name}.", "Export Loop Error")
                        continue

                filename_base = task['base_filename']
                filename = f"{filename_base}_{version_str}.step"

                if task["type"] == "connector":
                    current_export_dir = os.path.join(exportFolder, task["relative_export_path_dir"])
                    if not os.path.exists(current_export_dir): os.makedirs(current_export_dir)
                    full_path = os.path.join(current_export_dir, filename)
                else: 
                    full_path = os.path.join(exportFolder, filename)

                stepSaveOptions = exportMgr.createSTEPExportOptions(full_path, rootComp)
                exportMgr.execute(stepSaveOptions)
                exported_count += 1
            except Exception as e_loop:
                if ui: ui.messageBox(f'Failed during export of: {task.get("base_filename", f"Task {i+1}")}\n'
                                  f'Error: {traceback.format_exc()}\nSkipping this item.', 'Export Loop Error')
                continue 
        
        progressDialog.hide()

        if exported_count > 0:
            success_msg = f'Successfully exported {exported_count} STEP files'
            if exported_count < total_exports: 
                success_msg += f' (out of {total_exports} planned tasks).'
            else:
                success_msg += '.'
            success_msg += f'\nFiles saved to:\n{exportFolder}'
            if ui: ui.messageBox(success_msg, 'Export Complete')
        elif total_exports > 0 and ui: 
             ui.messageBox(f'Export process ran for {total_exports} planned items, but 0 files were successfully exported. Please check warnings or naming conventions.', 'Export Result')
        elif ui: 
            ui.messageBox('No files were exported as no tasks were identified or an early abort occurred.', 'Export Result')

    except Exception as e:
        if ui: ui.messageBox('Top-Level Script Failed Unexpectedly:\n{}'.format(traceback.format_exc()))
    finally:
        if 'progressDialog' in locals() and progressDialog and hasattr(progressDialog, 'isShowing') and progressDialog.isShowing:
            try: progressDialog.hide()
            except: pass