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