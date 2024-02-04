// This macro batch measures a folder of images,
// taking as imput only a folder with three channel segmentations, obtained
// via Ilastik. There should be no other types of files in the folder.
//The output it provides are the areas of the masks

macro "Batch Measure" {
    dir1 = getDirectory("Directory for SEGMENTED ");
    list1 = getFileList(dir1);
    
    thrval = getNumber("BACKground: 3 \n VASCulature: 255 \n CONNective tissue:1 \n CHOOSE THRESHOLD VALUE",0);
	        	
       if (getVersion>="1.40e")
        setOption("display labels", true);
        
    setBatchMode(true);
    for (i=0; i<list1.length; i++) {
        path1 = dir1+list1[i];
        showProgress(i, list1.length);
        if (!endsWith(path1,"/")) open(path1);
        if (nImages>=1) {     	
	
    selectWindow(list1[i]);
//run("Threshold...");
	setThreshold(thrval, thrval);
	run("Convert to Mask");
run("Set Measurements...", "area area_fraction display redirect=None decimal=3");

run("Measure");
				
		saveAs("Results", dir1+"Results-segmentation-"+thrval+".csv");
			 selectWindow("Results");
			 close();
        }
    }
}
