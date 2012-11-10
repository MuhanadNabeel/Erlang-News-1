<style type="text/css">


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



