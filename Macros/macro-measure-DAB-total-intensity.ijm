// This macro batch measures a folder of images.
// Use the Analyze>Set Measurements command
// to specify the measurement parameters. Check 
// "Display Label" in the Set Measurements dialog
// and the file names will be added to the first 
// column of the "Results" table.

macro "Batch Measure" {
    dir = getDirectory("Choose Directory for RAW ");
    list = getFileList(dir);
       if (getVersion>="1.40e")
        setOption("display labels", true);
    setBatchMode(true);
    for (i=0; i<list.length; i++) {
        path = dir+list[i];
        showProgress(i, list.length);
        if (!endsWith(path,"/")) open(path);
        if (nImages>=1) {
        	
		selectWindow(list[i]);
		run("IHC Profiler", "mode=[Cytoplasmic Stained Image] vectors=[H DAB]");
		selectWindow(list[i]+"-(DAB Stain)");
		run("Invert");
		run("Set Measurements...", "mean area display redirect=None decimal=3");
		run("Measure");
		saveAs("Results", dir+"Results-total.csv");
			close();
			close();
			close();
			selectWindow(list[i]);
			close();
        }
    }
}

