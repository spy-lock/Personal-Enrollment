Function copy-files {
	Param (
		[Parameter(Mandatory)]
		[string]$Source,        # The path to the source directory
		[Parameter(Mandatory)]
		[string]$Destination,   # The path to the destination directory
		[Parameter()]
		[string]$Activity = "Default"  # An optional activity name to display during the copy operation
	)

	# Get all the items (files and folders) in the source directory and its subdirectories
	$ItemsToCopy = Get-ChildItem $Source -Recurse -Force
	
	# Initialize variables to track the progress of the copy operation
	$TotalItems = $ItemsToCopy.Count  # Total number of items to be copied
	$CurrentItem = 0  # Number of items copied so far
	$PercentComplete = 0  # Percentage of items copied so far
	
	# Loop through each item in the list of items to copy
	ForEach ($Item in $ItemsToCopy) {
	    # Display progress information for the current item
	    Write-Progress -Activity $Activity -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete
	
	    # Get the full name of the item, trim the source directory path, and construct the destination path
	    $Name = $Item.FullName
	    $TrimmedName = $Name.Replace($Source, "").trim("\")
	    $DestinationFull = $Destination + '\' + $TrimmedName
	
	    # Copy the item from the source path to the destination path
	    Copy-Item -Path $Name -Destination $DestinationFull -Force -Verbose
	
	    # Update progress variables
	    $currentItem++
	    $percentcomplete = [int](($currentItem / $totalitems) * 100)
	}
	
}