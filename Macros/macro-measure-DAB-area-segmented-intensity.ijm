// This macro batch measures a folder of images,
// taking as imput raw DAB/HE images and three channel segmentations, obtained
// via Ilastik. The output it provides are the mean intensities of specifically masked 
// areas (background, connective, vascular) in the context of the whole visual image (+ non-selected)
// Data needs to be normalized to the areas of the masks (another macro) (possibly use background values as blank).


macro "Batch Measure" {
    dir1 = getDirectory("Directory for RAW ");
    list1 = getFileList(dir1);
    dir2 = getDirectory("_Directory for SEGMENTED ");
    list2 = getFileList(dir2);
    
    thrval = getNumber("BACKground: 3 \n VASCulature: 255 \n CONNective tissue:1 \n CHOOSE THRESHOLD VALUE",0);
	    
    	if (list1.length!=list2.length)
    	exit("Algorithm terminated: Different number of RAW/SEGMENTED files");
       if (getVersion>="1.40e")
        setOption("display labels", true);
        
    setBatchMode(true);
    for (i=0; i<list1.length; i++) {
        path1 = dir1+list1[i];
        path2 = dir2+list2[i];
        showProgress(i, list1.length);
        if (!endsWith(path2,"/")) open(path2);
        if (!endsWith(path1,"/")) open(path1);
        if (nImages>=1) {
        	
		selectWindow(list1[i]);
		run("IHC Profiler", "mode=[Cytoplasmic Stained Image] vectors=[H DAB]");
		selectWindow(list1[i]+"-(DAB Stain)");
		run("Invert");
		
			selectWindow(list2[i]);
			setAutoThreshold("Default dark");
			//run("Threshold...");
			call("ij.plugin.frame.ThresholdAdjuster.setMode", "B&W");

			setThreshold(thrval, thrval);
			setOption("BlackBackground", false);
			run("Convert to Mask");
			run("Invert");

			imageCalculator("Subtract create", list1[i]+"-(DAB Stain)", list2[i]);
			selectWindow("Result of "+list1[i]+"-(DAB Stain)");
					
		run("Set Measurements...", "area mean display redirect=None decimal=3");
		run("Measure");
		
		saveAs("Results", dir1+"Results-segment.mask-"+thrval+".csv");
			close();
			selectWindow(list1[i]);
			close();
			
        }
    }
}

