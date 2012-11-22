
<li data-id="{id}_left_item" id="left_{datatype}">
<div>
<div class="newsTemp" id="{datatype}">

	<div class="title">
		<table><tr><td style="vertical-align:top;"><img src="{image}" align="left" style="max-height:32px;max-width:32px;margin-top:10px;margin-right:-6px;"></td>
			<td><span class="main-title"><a style="cursor:pointer;" target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
           return true;" onmouseout="window.status=''" onclick="openBox('{URL}', '{title}', '{id}', '{datatype}');">{title}</a></span></td></tr></table>
		
		
	</div>
	<div align="right" style="height:.5em;background-color:#aacc77;"><div class="triangle-topright"></div></div>
	<div id="pub">Published: 2012-02-13</div>
	<table style="width:100%;" cellspacing="0" cellpadding="0">

		<tr><td class="voteButtons" >
			<div >
				<table>
					<tr><div class="vote-up" id="{id}_vote_up_{datatype}" onclick="articleAction(this,1,false)" align="center"><a id="{id}_up_vote_count" class="likes">{up}</a></div>
						<div class="vote-up-active" id="{id}_vote_up_{datatype}_active" onclick="articleAction(this,1,true)" align="center"><a id="{id}_up_vote_count_active" class="likes">{up}</a></div></tr>
					<tr><div class="vote-down" id="{id}_vote_down_{datatype}" onclick="articleAction(this,0,false)" align="center"><a id="{id}_down_vote_count" class="likes">{down}</a></div>
						<div class="vote-down-active" id="{id}_vote_down_{datatype}_active" onclick="articleAction(this,0,true)" align="center"><a id="{id}_down_vote_count_active" class="likes">{down}</a></div></tr>
				</table>
				</div>
			</td>
			<td style="width:2em;height:4em;"></td>
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
</br>
	<span class="readMore" style="font-size:8pt;"><a style="cursor:pointer;" style="font-size:6pt;" id="{id}_report" onclick="articleAction(this,2,false)">report article</a></span>
	
	<div style="height:1px;width:100%;background-color:#c6c6c6;"></div>

	</br>
</div>
</div>
</li>