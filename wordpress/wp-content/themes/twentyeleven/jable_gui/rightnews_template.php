<li data-id="{id}_right_item" data-type="right_{datatype}">
    <div>

    <div class="right_row" onclick="openUpStuff('{id}')">
                <div style="padding:0.5em;line-height:80%;">
                        <a class="right_title">{title}</a></br>
                        <span class="right_source" style="margin-left:12px;">Source: 
                        <a onclick="openBox('{URL}', '{title}', '{id}', '{datatype}')">{host}</a></span>  
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
                    <div style="width:100%;">
                        <div class="desc" style="line-height:130%;">{description}</div><span class="readMore" ><a style="cursor:pointer;"  target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
                            return true;" onmouseout="window.status=''" onclick="openBox('{URL}', '{title}', '{id}', '{datatype}')">Read more..</a></span>
                        <div class="seperator" style="margin-top:20px"></div>
                        <span class="readMore" style="font-size:8pt;">
                            <a style="cursor:pointer;" id="{id}_report" onclick="articleAction(this,2,false);fadeWindow('{id}_reported_window', 'reported!');">report article</a>
                        </span>
                        <div class="window" style="margin-top:-5px;" id="{id}_reported_window"><div id="{id}_reported_window_text"></div></div>
    
                    </div>
                    </td>
                </tr>
            </table>
            <table id="{id}_all_vote_buttons" style="display:none;">
                                <tr>
                                    <td>
                                        <div id="{id}_vote_up_{datatype}_extra" class="thumb-up-shadowed" onclick="articleAction(this,1,false);getNewsJSON(false, true)"></div>
                                        <div id="{id}_vote_up_{datatype}_extra_active" class="thumb-up-active-shadowed" onclick="articleAction(this,1,true);getNewsJSON(false, true)"></div>
                                    </td>
                                    <td>
                                        <div id="{id}_vote_down_{datatype}_extra" class="thumb-down-shadowed" onclick="articleAction(this,0,false);getNewsJSON(false, true)"></div>
                                        <div id="{id}_vote_down_{datatype}_extra_active" class="thumb-down-active-shadowed" onclick="articleAction(this,0,true);getNewsJSON(false, true)"></div>
                                    </td>
                                </tr>
                            </table>
            <div align="right" class="arrow-container">
                <div class="arrow-up"></div>
            </div>

        </div>
    </div>
    </div>
</li>