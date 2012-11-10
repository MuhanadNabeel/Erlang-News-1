<style type="text/css">

.right_title{
	font-family: "MyriadPro Regular";
	font-size: 0.8em;
	color: #4b4b4b;
	text-shadow:1px 1px 1px white;
	text-decoration: none;
}

.right_title a:link{;
}

.right_row{
	background-color: #eeeeee;
	border-top: 1px solid white;
	border-bottom: 1px solid #d4d4d4;
	max-width: 60%;
}
.right_row:hover{
	background-color: #eaeaea;
}

.thumb-up{
	margin-top: 0.2em;
    background:url(img/thumb-up.png) 0 0 no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
}
.thumb-up:hover{
	background:url(img/thumb-up.png) 0 -1.2em no-repeat;
    background-size: 100%;
}
.thumb-up:active{
	background:url(img/thumb-up.png) 0 -2.4em no-repeat;
    background-size: 100%;
}
.thumb-up-active{
	margin-top: 0.2em;
    background:url(img/thumb-up.png) 0 -2.4em no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
    display: none;
}


.thumb-down{
	margin-top: 0.2em;
    background:url(img/thumb-down.png) 0 0 no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
}
.thumb-down:hover{
	background:url(img/thumb-down.png) 0 -1.2em no-repeat;
    background-size: 100%;
}
.thumb-down:active{
	background:url(img/thumb-down.png) 0 -2.4em no-repeat;
    background-size: 100%;
}
.thumb-down-active{
	margin-top: 0.2em;
    background:url(img/thumb-down.png) 0 -2.4em no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
    display: none;
}

.right_source{
	font-family: "Times New Roman";
	font-size: 0.7em;
	font-style: italic;
	color: #8c8c8c;
	text-shadow:1px 1px 1px white;
	text-align: right;
	text-decoration: none;
}

</style>

<div class="right_row">
	<table>
		<td style="padding:0.2em">
			<div id="{id}_vote_up" class="thumb-up" onclick="articleAction(this,1,false)"></div>
			<div id="{id}_vote_up_active" class="thumb-up-active" onclick="articleAction(this,1,true)"></div>
			<div id="{id}_vote_down" class="thumb-down" onclick="articleAction(this,0,false)"></div>
			<div id="{id}_vote_down_active" class="thumb-down-active" onclick="articleAction(this,0,true)"></div>
		</td><td>
			<a class="right_title" href="redirect.php?id={id}&url={URL}">{title}</a></br>
			<span align="right" class="right_source">Source: <a class="right_source" style="color:#0c638c;font-size:0.8em;" href="">http://www.something.com/</a></span>
		</td>

	</table>
</div>