#!/usr/bin/env bash

APPDIR="$HOME/Sites"

# Finding the directory of the script ($ROOT)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  ROOT="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
ROOT="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

if [ -z "$1" ]; then
	echo -e "\033[31mNeeds at least 1 parameter. Please specify app name\033[0m"; exit 1
fi

if [ ! -d "$APPDIR" ]; then
	read -p "$APPDIR doesn't exist. Create it ?" -n 1 -r ANSWER
	echo # New line
	if [[ $ANSWER =~ ^[Yy]$ ]]; then
		mkdir $APPDIR
		if [ $? == 0 ]; then
			echo -e "\033[32mSuccessfully created $APPDIR\033[0m"
		else
			exit 1
		fi
	else
		echo -e "\033[31mNo app directory specified. You can edit APPDIR in the script to customize your app directory\033[0m"
	fi
fi

APPROOT="$APPDIR/$1"

mkdir "$APPROOT"

if [ $? == 0 ]; then
	echo -e "\033[32mSuccessfully created $APPROOT\033[0m"
else
	exit 1
fi

cd $APPROOT

# Installing

echo "Initializing git..."
git init
cp "$ROOT/skeletons/gitignore.default" "./.gitignore"

echo "Initializing NPM..."
npm init -y
npm install --save-dev webpack webpack-cli css-loader postcss-loader autoprefixer tailwindcss mini-css-extract-plugin clean-webpack-plugin copy-webpack-plugin

echo "Importing default files..."
mkdir "./src" "./src/img" "./src/js" "./src/style" "./src/fonts"
touch "./src/index.html" "./src/js/index.js" "./src/style/main.css"

cp "$ROOT/skeletons/htaccess.default" "./.htaccess"
cp "$ROOT/skeletons/webpack.default.js" "./webpack.config.js"
cp "$ROOT/skeletons/postcss.default.js" "./postcss.config.js"

echo "import '../style/main.css';
console.log('Hello World!');" > ./src/js/index.js

echo "@tailwind base;
@tailwind components;
@tailwind utilities;" > ./src/style/main.css

echo "<!DOCTYPE html>
<html>
	<head>
		<title>$1</title>
		<meta charset=\"utf-8\">
		<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
		<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
		<link href=\"style/main.css\" rel=\"stylesheet\" />
	</head>
	<body>
		<div id=\"app\">
			<h1>$1</h1>
		</div>
		<script src=\"js/bundle.js\"></script>
	</body>
</html>" > ./src/index.html

# Add scripts to package.json
echo -e "\033[36m[ package.json ]\033[0m"
echo "Configuring npm scripts..."
sed -i '' '/  "scripts": {/a\
\ \ \ \ "prod": "webpack --mode production",\
\ \ \ \ "dev": "webpack --mode development",\
\ \ \ \ "watch": "webpack --watch --mode development",\
' package.json
cat package.json

# Enable Tailwind JIT Mode
echo -e "\033[36m[ tailwind.config.js ]\033[0m"
npx tailwindcss init
sed -i '' 's/content: \[\]/content: \['\''\.\/src\/\*\*\/\*.{html,js,php}'\''\]/' tailwind.config.js
cat tailwind.config.js

# First commit
echo -e "\033[36m[ First commit ]\033[0m"
git add .
git commit -m "First commit"

# Run dev script
echo -e "\033[36m[ Development script ]\033[0m"
npm run dev

# End
echo -e "\033[32mAll done!\033[0m"
exit 0
