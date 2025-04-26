#Fusion360API Python Script
#Description: Exports STEP files. Exports "Support" once per depth,
#             and "Shelf" for each width/depth combination.

import adsk.core, adsk.fusion, adsk.cam, traceback, os

def run(context):
    ui = None
    try:
        # --- Basic Fusion 360 setup ---
        app = adsk.core.Application.get()
        ui = app.userInterface
        design = app.activeProduct
        if not design:
            ui.messageBox('No active Fusion 360 design', 'Export Script Error')
            return

        # --- Get Document Version ---
        doc = app.activeDocument
        version_str = "v_unknown" # Default in case of error
        try:
            if doc.dataFile:
                version_number = doc.dataFile.versionNumber
                version_str = f"v{version_number}"
            else:
                version_str = "v_unsaved"
                ui.messageBox('The current document has not been saved to the cloud yet.\n'
                              'Filenames will use "v_unsaved" instead of a version number.',
                              'Unsaved Document Warning')
        except Exception as e:
             ui.messageBox(f'Could not retrieve document version:\n{e}\n'
                           f'Filenames will use "{version_str}".', 'Version Error')
        # --- End Get Document Version ---

        # --- Configuration
        widthParamName = "shelf_width_units"
        depthParamName = "shelf_depth_units"
        minWidth = 4
        maxWidth = 15
        minDepth = 7
        maxDepth = 15
        baseFileName = "homeracker_shelf"
        shelfBodyName = "Shelf"
        supportBodyName = "Support"
        # --- End Configuration ---

        # Get the root component
        rootComp = design.rootComponent

        # Get User Parameters collection
        userParams = design.userParameters
        if not userParams:
            ui.messageBox('Could not access user parameters.', 'Export Script Error')
            return

        # Find the specific parameters
        widthParam = userParams.itemByName(widthParamName)
        depthParam = userParams.itemByName(depthParamName)
        if not widthParam or not depthParam:
            ui.messageBox(f'Could not find parameters: "{widthParamName}" or "{depthParamName}". Check names.', 'Param Error')
            return

        # --- Find the bodies to control visibility (once before loops) ---
        shelfBody = None
        supportBody = None
        try:
            shelfBody = rootComp.bRepBodies.itemByName(shelfBodyName)
            supportBody = rootComp.bRepBodies.itemByName(supportBodyName)
            if not shelfBody:
                ui.messageBox(f'Body "{shelfBodyName}" not found. Aborting...', 'Body Not Found Warning')
                return
            if not supportBody:
                ui.messageBox(f'Body "{supportBodyName}" not found. Aborting...', 'Body Not Found Warning')
                return
        except Exception as e:
             ui.messageBox(f'Error finding bodies:\n{traceback.format_exc()}', 'Error Finding Bodies')
             return

        # --- Get Export Directory from User ---
        folderDialog = ui.createFolderDialog()
        folderDialog.title = "Select Folder to Save STEP Files"
        dialogResult = folderDialog.showDialog()
        if dialogResult == adsk.core.DialogResults.DialogOK:
            exportFolder = folderDialog.folder
        else:
            ui.messageBox('Export cancelled by user.')
            return

        # --- Get Export Manager ---
        exportMgr = design.exportManager

        # --- Progress Bar Setup ---
        num_depths = (maxDepth - minDepth + 1)
        num_widths = (maxWidth - minWidth + 1)
        # Total exports = one support per depth + one shelf per width*depth
        total_exports = num_depths + (num_depths * num_widths)
        progressDialog = ui.createProgressDialog()
        progressDialog.isCancelEnabled = False
        progressDialog.show(f'Exporting {baseFileName}', 'Initializing...', 0, total_exports)
        exported_count = 0

        # --- Loop through parameter combinations ---
        for d in range(minDepth, maxDepth + 1):
            try:
                # --- Set Depth Parameter ---
                depthParam.value = float(d)
                adsk.doEvents() # Allow update

                progressDialog.progressValue = exported_count
                progressDialog.message = f'Exporting Support: D={d} ({exported_count + 1}/{total_exports})'
                adsk.doEvents()

                # Set visibility: Support ONLY
                supportBody.isLightBulbOn = True
                shelfBody.isLightBulbOn = False # Hide shelf if it exists
                adsk.doEvents() # Allow visibility change

                # Construct filename & path for Support
                supportFileName = f"{baseFileName}_Support_D{d}_{version_str}"
                supportFullPath = os.path.join(exportFolder, supportFileName + ".step")

                # Export Support
                supportStepOptions = exportMgr.createSTEPExportOptions(supportFullPath, rootComp)
                exportMgr.execute(supportStepOptions)
                exported_count += 1
                # --- End Support Export ---

            except Exception:
                 progressDialog.hide() # Hide progress on error
                 ui.messageBox(f'Failed during processing or Support export for Depth={d}:\n{traceback.format_exc()}', 'Outer Loop Error')
                 return

            # --- INNER LOOP: Width (for Shelf Export) ---
            for w in range(minWidth, maxWidth + 1):
                try:
                    progressDialog.progressValue = exported_count
                    progressDialog.message = f'Exporting Shelf: W={w}, D={d} ({exported_count + 1}/{total_exports})'
                    adsk.doEvents()

                    # --- Set Width Parameter ---
                    widthParam.value = float(w)
                    adsk.doEvents() # Allow update

                    # --- Set Visibility for Shelf Export: Shelf ONLY ---
                    shelfBody.isLightBulbOn = True
                    supportBody.isLightBulbOn = False # Hide support if it exists
                    adsk.doEvents() # Allow visibility change

                    # --- Construct Filename & Path for Shelf ---
                    shelfFileName = f"{baseFileName}_Shelf_W{w}_D{d}_{version_str}"
                    shelfFullPath = os.path.join(exportFolder, shelfFileName + ".step")

                    # --- Export Shelf ---
                    shelfStepOptions = exportMgr.createSTEPExportOptions(shelfFullPath, rootComp)
                    exportMgr.execute(shelfStepOptions)
                    exported_count += 1

                except Exception as e_inner:
                    # Log error for this specific shelf, but continue loop
                    ui.messageBox(f'Failed exporting Shelf W={w}, D={d}:\n{traceback.format_exc()}\nSkipping this combination.', 'Inner Loop Error')
                    # Optionally add logging here instead of message box spam
                    continue # Continue to next width value

        # --- Clean up ---
        progressDialog.hide()

        if exported_count > 0:
             ui.messageBox(f'Successfully exported {exported_count} STEP files to:\n{exportFolder}', 'Export Complete')
        else:
             ui.messageBox('No files were exported. Check script configuration or logs for errors.', 'Export Result')

    except Exception as e:
        if ui:
            ui.messageBox('Script Failed Unexpectedly:\n{}'.format(traceback.format_exc()))
        if 'progressDialog' in locals() and progressDialog.isShowing:
            progressDialog.hide()
