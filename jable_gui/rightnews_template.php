<style type="text/css">

.right_title{
	font-family: "MyriadPro Regular";
	font-size: 0.8em;
	color: #4b4b4b;
	text-shadow:1px 1px 1px white;
	text-decoration: none;
    cursor: pointer;
}

.arrow-up{
    width: 0;
    height: 0;
    border-left: 0.5em solid transparent;
    border-right: 0.5em solid transparent;
    border-bottom: 1em solid white;
    margin-right: 1.5em;
    margin-bottom: 0.1em;
}

.right_row{
	background-color: #eeeeee;
	border-bottom: 1px solid #d4d4d4;
	width: 100%;
    padding: .4em;
    padding-right: 0;
    padding-left: 1em;
    cursor: pointer;
}
.right_row{
    background-color: #eeeeee;
    border-bottom: 1px solid #d4d4d4;
    width: 100%;
    padding: .4em;
    padding-right: 0;
    padding-left: 1em;
    cursor: pointer;
}
.right_row:hover{
	background-color: #eaeaea;
}
.right_row:hover a.right_title{
    color:#222222;
}
.right-bottom-line{
    background-color: white;
    width:21.4em;
    height:1px;
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
.right_source a:link{
    color:#0c638c;
    font-size:1em;
    text-decoration: none;
}
.right_source a:hover{
    color: #2497cd;
}
.right_source a:visited{
    color: #0c638c;
}

.desc{
    font-size: 10pt;
    text-shadow:1px 1px 0px white;
    color: #222222;
}

.right_content{
    width:21.4em;
    background-color:#f6f6f6;
    padding: 0;
    height:0;
    overflow: hidden;
}

/*f9f9f9*/
</style>

<div style="max-width:20.4em;">
    <div class="right_row" onclick="openUpStuff('{id}')">
                        <a class="right_title">{title}</a></br>
                        <span class="right_source" style="margin-left:12px;">Source: 
                        <a target="_blank" href="redirect.php?id={id}&url={URL}">{host}</a></span>    
    </div>
    
</div>
<div id="{id}_expand" class="right_content">
    <div id="{id}_content">
        <div style="background-color:#aacc77;width:100%;height:0.1em;"></div>
        <table>
            <tr>
                <td style="vertical-align:top;display:inline-block;">
                    <div style="padding:0.5em;">
                        <div id="{id}_vote_up" class="thumb-up" onclick="articleAction(this,1,false)"></div>
                        <div id="{id}_vote_up_active" class="thumb-up-active" onclick="articleAction(this,1,true)"></div>
                        <div id="{id}_vote_down" class="thumb-down" onclick="articleAction(this,0,false)"></div>
                        <div id="{id}_vote_down_active" class="thumb-down-active" onclick="articleAction(this,0,true)"></div>
                    </div>
                </td>
                <td>
                <div class="content"><a class="desc">{description}</a><span class="readMore"><a href="redirect.php?id={id}&url={URL}" target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
                    return true;" onmouseout="window.status=''">Read more..</a></span>
                    <div style="width:16em;height:1px;background-color:#c6c6c6;border-bottom:1px solid white;margin-top:0.5em;"></div>
                </div>
                </td>
            </tr>
        </table>
        <div align="right" style="width:100%;vertical-align:bottom;margin-bottom:2em;">
            <div class="arrow-up"></div>
        </div>

    </div>
</div>
<div class="right-bottom-line"></div>



