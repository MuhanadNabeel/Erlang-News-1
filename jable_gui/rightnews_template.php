<li data-id="{id}_right_item" data-type="right_{datatype}">
    <div>

    <div class="right_row" onclick="openUpStuff('{id}')">
                <div style="padding:.4em; padding-left:1em;">

                        <a class="right_title">{title}</a></br>
                        <span class="right_source" style="margin-left:12px;">Source: 
                        <a target="_blank" href="redirect.php?id={id}&url={URL}">{host}</a></span>  
                </div>  
    </div>
    </div>
    <div id="{id}_expand" class="right_content">
        <div id="{id}_content">
            <div class="green-seperator"></div>
            <table>
                <tr>

                    <td class="voting">
                        <div>
                            <div id="{id}_vote_up_{datatype}" class="thumb-up" onclick="articleAction(this,1,false)"></div>
                            <div id="{id}_vote_up_{datatype}_active" class="thumb-up-active" onclick="articleAction(this,1,true)"></div>
                            <div id="{id}_vote_down_{datatype}" class="thumb-down" onclick="articleAction(this,0,false)"></div>
                            <div id="{id}_vote_down_{datatype}_active" class="thumb-down-active" onclick="articleAction(this,0,true)"></div>
                        </div>
                    </td>
                    <td>
                    <div><div class="desc">{description}</div>
                        <span class="readMore">
                            <a href="redirect.php?id={id}&url={URL}" target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
                            return true;" onmouseout="window.status=''">Read more..</a>--></span>
                        <div class="seperator"></div>
                    </div>
                    </td>
                </tr>
            </table>
            <div align="right" class="arrow-container">
                <div class="arrow-up"></div>
            </div>

        </div>
    </div>
    <div class="right-bottom-line"></div>
    </div>
</li>