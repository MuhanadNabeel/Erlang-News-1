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
	font-family: "Condenced";
	font-size: 1em;
	color: #aacc77;
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

.vote-up{
	padding-top: 0.1em;
	background:url(img/vote-up.png) 0 0 no-repeat;
	background-size: 100%;
	height: 2.4em;
	width: 2em;
}

.vote-up:hover{
	background:url(img/vote-up-hover.png) 0 0 no-repeat;
	background-size: 100%;
}
.vote-up:active{
	background:url(img/vote-up-active-hover.png) 0 0 no-repeat;
	background-size: 100%;
}




.vote-up-active{
	background:url(img/vote-up-active.png) 0 0 no-repeat;
	background-size: 100%;
	height: 2.4em;
	width: 2em;
	padding-top: 0.1em;
	display:none;
}

.vote-up-active:active{
	background:url(img/vote-up-active-hover.png) 0 0 no-repeat;
	background-size: 100%;
}


.vote-down{
	margin-top: -0.1em;
	padding-top: 1.5em;
	background:url(img/vote-down.png) 0 0 no-repeat;
	background-size: 100%;
	height: 2.4em;
	width: 2em;
}
.vote-down:hover{
	background:url(img/vote-down-hover.png) 0 0 no-repeat;
	background-size: 100%;
}
.vote-down:active{
	background:url(img/vote-down-active-hover.png) 0 0 no-repeat;
	background-size: 100%;
}

.vote-down-active{
	margin-top: -0.1em;
	background:url(img/vote-down-active.png) 0 0 no-repeat;
	background-size: 100%;
	height: 2.4em;
	width: 2em;
	padding-top: 1.5em;
	display:none;
}
.vote-down-active:active{
	background:url(img/vote-down-active-hover.png) 0 0 no-repeat;
	background-size: 100%;
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
	font:bold 0.75em "Condenced";
	text-shadow: 0.067em 0.067em 0.1em black;
	color:white;
	vertical-align: top;
}

.triangle-topright {
	width: 0;
	height: 0;
	border-top: 1em solid white;
	border-left: 1em solid transparent;
}

.link a:link{
	text-decoration: none;
	color:black;
}

.link a:visited {color:black;}  /* visited link */
.link a:hover {color:#aacc77;}  /* mouse over link */
.link a:active {color:#74a22f;}

.readMore a:link{color:#aacc77; text-decoration: none;}
.readMore a:hover {color:#74a22f;}
.readMore a:visited {color:#aacc77;}  /* mouse over link */
.readMore a:active {color:black;}

</style>



<div class="newsTemp">

	<div class="title">
		<img src="{image}" align="left" style="max-height:32px;max-width:32px;">
		<span class="link"><a href="redirect.php?id={id}&url={URL}" target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
           return true;" onmouseout="window.status=''">{title}</a></span>
	</div>
	<div align="right" style="height:1em;background-color:#aacc77;"><div class="triangle-topright"></div></div>
	<div id="pub">Published: 2012-02-13</div>
	<table style="width:100%;">
		<tr>
			<div style="width:100%;height:8em;background-color:gray;">{vote_bar}</div>
		</tr>
		<tr><td class="voteButtons" onmouseover="jQuery(this).fadeTo('fast', 1)">
				<table>
					<tr><div class="vote-up" id="{id}_vote_up" onclick="articleAction(this,1,false)" align="center"><a class="likes">{up}</a></div>
						<div class="vote-up-active" id="{id}_vote_up_active" onclick="articleAction(this,1,true)" align="center"><a id="{id}_up_vote_count" class="likes">{up}</a></div></tr>
					<tr><div class="vote-down" id="{id}_vote_down" onclick="articleAction(this,0,false)" align="center"><a class="likes">{down}</a></div>
						<div class="vote-down-active" id="{id}_vote_down_active" onclick="articleAction(this,0,true)" align="center"><a id="{id}_down_vote_count" class="likes">{down}</a></div></tr>
				</table>
			</td>
			<td><div class="content">
			{description} <span class="readMore"><a href="redirect.php?id={id}&url={URL}" target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
           return true;" onmouseout="window.status=''">Read more..</a></span></div></td>
			</tr>

	</table>
</br>
	<span class="readMore"><a href="#" style="font-size:0.7em;" id="{id}_report" onclick="articleAction(this,2,false)">report article</a></span>
	<div style="height:1px;width:100%;background-color:#c6c6c6;"></div>

	</br>
</div>