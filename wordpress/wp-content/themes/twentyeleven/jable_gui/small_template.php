
<li data-id="{id}_left_item" id="left_{datatype}">
<div>
<div class="newsTemp" id="{datatype}">

	<div class="title">
		<table cellspacing="0" cellpadding="0"><tr><td style="vertical-align:top;padding-right:5px;">
			<img src="{icon}" align="left" style="height:18px;width:18px;margin-top:6px;margin-right:0px;visibility:{icon_hide};"></td>
			<td><span class="main-title"><a style="cursor:pointer;" target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
           return true;" onmouseout="window.status=''" onclick="openBox('{URL}', '{title}', '{id}', '{datatype}')">{title}</a></span></td></tr></table>
		
		
	</div>
	<div align="right" style="height:.5em;background-color:#aacc77;"><div class="triangle-topright"></div></div>
	<div id="pub">Published: {pubdate}</div>
	<table style="width:100%;margin-bottom:5px;" cellspacing="0" cellpadding="0">

		<tr><td class="voteButtons">
			<div >
				<table>
					<tr><div class="vote-up" id="{id}_vote_up_{datatype}" onclick="articleAction(this,1,false)" align="center"><a id="{id}_up_vote_count" class="likes">{up}</a></div>
						<div class="vote-up-active" id="{id}_vote_up_{datatype}_active" onclick="articleAction(this,1,true)" align="center"><a id="{id}_up_vote_count_active" class="likes">{up}</a></div></tr>
					<tr><div class="vote-down" id="{id}_vote_down_{datatype}" onclick="articleAction(this,0,false)" align="center"><a id="{id}_down_vote_count" class="likes">{down}</a></div>
						<div class="vote-down-active" id="{id}_vote_down_{datatype}_active" onclick="articleAction(this,0,true)" align="center"><a id="{id}_down_vote_count_active" class="likes">{down}</a></div></tr>
				</table>
				</div>
			</td>
			<td><div class="content">
			<div style="line-height:100%;">{description}</div> <span class="readMore" style="cursor:pointer;" onclick="openBox('{URL}', '{title}', '{id}', '{datatype}')">Read more..</span></div></td>
				
				
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
                


			</tr>

	</table>
	<div style="vertical-align:top;width:100%;position:relative;height:10pt;">
		<div style="position:absolute;left:0;margin-top:10px;">
			<span class="readMore" style="font-size:8pt;">
				<a style="cursor:pointer;color:#b9b9b9" id="{id}_report" onclick="articleAction(this,2,false);fadeWindow('{id}_reported_window', 'reported!');">report article</a>
				<a style="cursor:pointer;display:none;color:#b20000" id="{id}_report_active" onclick="articleAction(this,2,true);fadeWindow('{id}_reported_window', 'unreported!');">unreport article</a>
			</span>
		</div>
		<div style="position:absolute;right:0;margin-top:10px;">
			<span class="right_source" style="font-size:8pt;">Source: 
		        <a onclick="openBox('{URL}', '{title}', '{id}', '{datatype}')" style="font-size:8pt;cursor:pointer;">{host}</a>
		    </span>
	    </div>
	
	<div class="window" id="{id}_reported_window"><div id="{id}_reported_window_text"></div></div>
	</div>



		<div style="height:1px;width:100%;background-color:#c6c6c6;"></div>
	

	</br>
</div>
</div>
</li>