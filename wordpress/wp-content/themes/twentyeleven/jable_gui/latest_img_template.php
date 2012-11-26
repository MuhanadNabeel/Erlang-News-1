<li data-id="{id}_right_item" data-type="right_{datatype}">
    <div>

    <div class="right_row" onclick="openUpStuff('{id}')">
        <table><tr><td style="vertical-align:middle;"><img src="{image}" style="border:solid 1px gray;margin-left:5px;margin-right:0px;max-width:40px;"></td>
            <td style="vertical-align:top;">
                <div style="padding:0.5em;line-height:80%;">
                        <a class="right_title">{title}</a></br>
                        <span class="right_source" style="margin-left:12px;"> 
                        <a onclick="openBox('{URL}', '{title}', '{id}', '{datatype}')">{host}</a></span>
                        <div style="clear:both"></div>
                </div>
            </td>
        </tr></table>
    </div>
    </div>
    <div id="{id}_expand" class="right_content">
        <div id="{id}_content">
            <div class="blue-seperator"></div>
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
                        <div class="blue-desc" style="line-height:130%;">{description}</div><span class="blue-readMore" ><a style="cursor:pointer;"  target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
                            return true;" onmouseout="window.status=''" onclick="openBox('{URL}', '{title}', '{id}', '{datatype}')">Read more..</a></span>
                        <div class="seperator" style="margin-top:20px"></div>
                        
                        <div class="right_source" style="width:100%;float:right;margin-right:5px;">Published: {pubdate}</div>


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