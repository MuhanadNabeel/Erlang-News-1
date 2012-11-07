<style>

@font-face {
  font-family: "Condenced";
  src: url(fonts/MyriadPro-Cond.otf) format("opentype");
}

.newsTemp{
	margin: 10px;
}
.title{
	margin: 0px;
	font-family: "Condenced";
	font-size: 1.6em;
}
.content{
	margin-right: 20px;
	padding: 10px;
	text-decoration: none;
}

.readMore{
	margin: 10px;
	text-decoration: none;
	font-family: "Condenced";
	font-size: 1em;
	color:#79a8be;
}
.readMore:hover{
	color:#245870;
}

#pub{
	font: italic 0.7em "Condenced";
	color: #c6c6c6;
}

.voteButtons{
	margin-right: 20px;
	padding: 5px;
	height:40px;
	vertical-align:top;
	opacity:0.1;
	filter:alpha(opacity=10); /* For IE8 and earlier */
}
.voteButtons:hover{
	opacity: 1;
	filter:alpha(opacity=100); /* For IE8 and earlier */
}

.vote-up{
	background:url(img/vote_up.png) 0 0 no-repeat;
	background-size: 100%;
	height: 1.65em;
	width: 2em;
}

.vote-up:hover{
	background:url(img/vote_up.png) 0 -3.2497em no-repeat;
}
.vote-up:active{
	background:url(img/vote_up.png) 0 -6.4994em no-repeat;
}

.vote-down{
	background:url(img/vote_down.png) 0 -1.65em no-repeat;
	background-size: 100%;
	height: 1.65em;
	width: 2em;
}
.vote-down:hover{
	background:url(img/vote_down.png) 0 -4.8765em no-repeat;
}
.vote-down:active{
	background:url(img/vote_down.png) 0 -8.1494em no-repeat;
}


.window{
	text-align: center;
	position: absolute;
	padding-top:0.38em;
	padding-left: 0.28em; 
	margin-left: 2.2em;
	background:url(img/window.png) 0 0 no-repeat;
	background-size: 100%;
	height: 3em;
	width: 3em;
	display: none;
	opacity: 0.8;
	filter:alpha(opacity=80);
}

.likes{
	height: 100%;
	width: 100%;
	font:bold 1em "Condenced";
	font-size: 1em;
	text-shadow: 0.067em 0.067em 0.1em black;
	color:white;
}

.triangle-topright {
	width: 0;
	height: 0;
	border-top: 1em solid white;
	border-left: 1em solid transparent;
}

</style>



<div class="newsTemp">

	<div class="title">
		<img src="{image}" align="left" style="max-height:32px;max-width:32px;">{title}
	</div>
	<div align="right" style="height:1em;background-color:#aacc77;"><div class="triangle-topright"></div></div>
	<div id="pub">Published: 2012-02-13</div>
	<table style="width:100%;">
		<tr>
			<div style="width:100%;height:8em;background-color:gray;"></div>
		</tr>
		<tr><td class="voteButtons">
				<table>
					<div id="window1" class="window"><a class="likes">13</a></div>
					<tr><div class="vote-up" onmouseover="fade(window1)" onmouseout="fade(window1)"></div>
						<div id="window2" class="window"><a class="likes">13</a></div></tr>
					<tr><div class="vote-down" onmouseover="fade(window2)" onmouseout="fade(window2)"></div></tr>
				</table>
			</td>
			<td><div class="content">
			{description} <a class="readMore" href="#">Read more..</a></div></td>
			</tr>

	</table>
</br>
	<a href="#" class="readMore" style="font-size:0.7em;">report article</a>
	<div style="height:1px;width:100%;background-color:#c6c6c6;"></div>

	</br>
</div>