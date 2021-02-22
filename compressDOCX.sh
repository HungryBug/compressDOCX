## useage:
## 1. download ImageOptim and ImageAlpha
## https://imageoptim.com/ImageOptim.tbz2 or brew install imageoptim
## https://pngmini.com/ImageAlpha1.5.1.tar.bz2 or brew cask install imagealph
## 2. unzip ImageOptim.tbz2 and ImageAlpha1.5.1.tar.bz2 to /Applications
## 3. brew install imageoptim-cli
## 4. brew install OptiPNG
## 5. chmod +x compressDOCX.sh
## ./compressDOCX.sh report.docx
## ./compressDOCX.sh report.pptx



## help banner
if [ $# -ne 1 ] ;then
    echo "\n#################################################"
    echo "#     Usage:                                    #"
    echo "#     ./compressDOCX.sh report.docx             #"
    echo "#     ./compressDOCX.sh report.pptx             #"
    echo "#                                               #"
    echo "#################################################\n"
    exit
fi

## get full file name
filename=$1
# echo $filename

## install imageoptim
which "/Applications/ImageOptim.app/Contents/MacOS/ImageOptim" > /dev/null
if [ $? -eq 1 ];then
	brew install imageoptim
fi

## install imagealpha
which "/Applications/ImageAlpha.app/Contents/MacOS/ImageAlpha" > /dev/null
if [ $? -eq 1 ];then
	brew cask install imagealph
fi

## install imageoptim-cli
which "/usr/local/bin/imageoptim" > /dev/null
if [ $? -eq 1 ];then
	brew install imageoptim-cli
fi

## install OptiPNG
which "/usr/local/bin/optipng" > /dev/null
if [ $? -eq 1 ];then
	brew install OptiPNG
fi

## get file name and ext name
file=${filename%.*}
# echo $file
ext=${filename##*.}
# echo $ext
type=""
temp_path=""

## is file exist
if [ ! -e $filename ];then
	echo "File not exist."
fi

## is file type currect
if [ "$ext"x != "docx"x ] && [ "$ext"x != "pptx"x ];then
	echo "Only support docx or pptx file."
fi

## is docx/pptx file
if [ "$ext" == "docx" ];then
	type="word"
	temp_path="${file}_word_temp"
elif [ "$ext" == "pptx" ];then
	type="ppt"
	temp_path="${file}_ppt_temp"
fi
# echo ${temp_path}
mkdir -p ${temp_path}/${type}/media
# echo "$path"

## back up file
cp ${filename} ${filename}.bak

## unzip pic to each type directory
unzip $filename "$type/media/*.tiff" -d ${temp_path}/tiff -f -o;
unzip $filename "$type/media/*.png" -d ${temp_path}/png -f -o;
unzip $filename "$type/media/*.jpg" -d ${temp_path}/jpg -f -o;
unzip $filename "$type/media/*.jpeg" -d ${temp_path}/jpg -f -o;

## compress tiff file
if [ -d ${temp_path}/tiff/${type} ];then
	optipng ${temp_path}/tiff/${type}/media/*.tiff;
	/bin/rm ${temp_path}/tiff/${type}/media/*.tiff;
	for i in ${temp_path}/tiff/${type}/media/*.png;do mv "$i" "${i%.png}.tiff";done;
	mv ${temp_path}/tiff/${type}/media/*.tiff ${temp_path}/${type}/media/;
fi

## compress png file
if [ -d ${temp_path}/png/${type} ];then
	imageoptim --imagealpha "${temp_path}/png/${type}/media/*.png"
	# optipng ${temp_path}/png/${type}/media/*.png;
	mv ${temp_path}/png/${type}/media/*.png ${temp_path}/${type}/media/
fi

## compress jpg/jpeg file
if [ -d ${temp_path}/jpg/${type} ];then
	imageoptim "${temp_path}/jpg/${type}/media/*.jpg"
	imageoptim "${temp_path}/jpg/${type}/media/*.jpeg"
	# optipng ${temp_path}/jpg/${type}/media/*.jpg;
	# optipng ${temp_path}/jpg/${type}/media/*.jpeg;
	mv ${temp_path}/jpg/${type}/media/*.jpg ${temp_path}/${type}/media/
	mv ${temp_path}/jpg/${type}/media/*.jpeg ${temp_path}/${type}/media/
fi

## zip pic to word/ppt
cd ${temp_path}
zip -u ../$filename ${type}/media/*;

## delete temp directory
cd ..
/bin/rm -rf ${temp_path};

echo "All done."
