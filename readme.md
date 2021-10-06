# autoinit.sh

A custom script that runs my common new project tasks. Inspired by [createapp.dev](https://createapp.dev), it automatically setups git, npm, installs & configure webpack & tailwindcss.

### Usage

```
autoinit [appname]
```

### Tasks order :

1. Create an app directory in $HOME/Sites/

2. Initialize git

3. Initialize npm

4. Install the following dependencies :

   ```webpack webpack-cli css-loader postcss-loader autoprefixer tailwindcss mini-css-extract-plugin clean-webpack-plugin copy-webpack-plugin```

5. Create directory structure and import skeleton files as follow :

   ```
   app/
   ├ src/
   │ ├ fonts/
   │ ├ img/
   │ ├ js/
   │ │ └ index.js
   │ ├ style/
   │ │ └ main.css
   │ └ index.html
   ├ .gitignore
   ├ package.json
   ├ postcss.config.js
   ├ tailwind.config.js
   └ webpack.config.js
   ```

6. Add following scripts to package.json :

   ```json
   "prod": "webpack --mode production",
   "dev": "webpack --mode development",
   "watch": "webpack --watch --mode development",
   ```

7. Configure Tailwind in JIT Mode

8. Create the first commit

9. Runs `npm run dev`

### Webpack default configuration

```javascript
const path = require('path');
const CopyPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
	entry : './src/js/index.js',
	output : {
		filename : 'bundle.js',
		path : path.resolve(__dirname, 'dist/js'),
	},
	module : {
		rules : [
			{
				test : /\.css$/,
				use : [
					MiniCssExtractPlugin.loader,
					{
						loader : 'css-loader',
						options : {
							importLoaders : 1
						}
					},
					'postcss-loader'
				]
			}
		]
	},
	plugins: [
		new CopyPlugin({
			patterns: [
				{ from: 'src/index.html', to:'../' },
				{ from: 'src/img', to:'../img' },
				{ from: 'src/fonts', to:'../fonts' },
			],
		}),
		new MiniCssExtractPlugin({
			filename: "../style/[name].css"
		  }),
		new CleanWebpackPlugin()
	]
}
```

### Warnings

This script as been written to be used on macOS and for my personal needs only. It might not run correctly on other systems. Please note :

- The default app directory is setup to $HOME/Sites, which would be /Users/username/Sites on macOS. You can edit the APPDIR variable as you wish, or create a symlink that points to your server's root.
- The script uses BSD/macOS version of sed. It has not be tested on GNU systems and might fail because of differences between sed versions.

### Future updates

I might update the script to incorporate more feature like vue.js dependencies, and make it more customizable, as it is specific for my own needs for now. Feel free to modify it as you wish.

