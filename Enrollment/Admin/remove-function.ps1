#Function to remove files and directories at a specified path
Function Remove-Files {

	# Define parameters
	Param (
		[Parameter(Mandatory)]
		[string]$Path,       # Path where files and directories need to be deleted
		
		[Parameter()]
		[string]$Activity = "Default"   # Activity being performed
	)
	
	# Get all files at the specified path (including subdirectories) and store them in $ItemsToDelete
	$ItemsToDelete = Get-ChildItem $Path -Recurse -File -Force
	
	# Calculate total number of items to be deleted and initialize variables for progress tracking
	$TotalItems = $ItemsToDelete.Count
	$CurrentItem = 0
	$PercentComplete = 0
	
	# Loop through each item in $ItemsToDelete and delete it
	ForEach ($Item in $ItemsToDelete) {
	    # Update progress bar
	    Write-Progress -Activity $Activity -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete
	
	    # Delete current item
	    Remove-Item $item.FullName -Force -Confirm:$false
	
	    # Update progress variables
	    $currentItem++
	    $percentcomplete = [int](($currentItem / $totalitems) * 100)
	}
	
	# Clean up remaining directories (if any)
	Write-Progress -Activity "Cleaning up directories..." -Status Waiting -PercentComplete $PercentComplete
	Start-Sleep -Seconds 2
	Get-ChildItem $Path -Directory -Recurse | Remove-Item -Recurse -Force -Confirm:$false -Verbose
	
}