<div class="newsTemp">

	<div class="title">
		<table><tr><td style="vertical-align:top;"><img src="{image}" align="left" style="max-height:32px;max-width:32px;margin-top:10px;margin-right:-6px;"></td>
			<td><span class="link"><a href="redirect.php?id={id}&url={URL}" target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
           return true;" onmouseout="window.status=''">{title}</a></span></td></tr></table>
		
		
	</div>
	<div align="right" style="height:1em;background-color:#aacc77;"><div class="triangle-topright"></div></div>
	<div id="pub">Published: 2012-02-13</div>
	<table style="width:100%;">
		<tr>
			<div style="width:100%;height:8em;background-color:gray;">{vote_bar}</div>
		</tr>

		<tr><td class="voteButtons" >
				<table>
					<tr><div class="vote-up" id="{id}_vote_up" onclick="articleAction(this,1,false)" align="center"><a class="likes">{up}</a></div>
						<div class="vote-up-active" id="{id}_vote_up_active" onclick="articleAction(this,1,true)" align="center"><a id="{id}_up_vote_count" class="likes">{up}</a></div></tr>
					<tr><div class="vote-down" id="{id}_vote_down" onclick="articleAction(this,0,false)" align="center"><a class="likes">{down}</a></div>
						<div class="vote-down-active" id="{id}_vote_down_active" onclick="articleAction(this,0,true)" align="center"><a id="{id}_down_vote_count" class="likes">{down}</a></div></tr>
				</table
			</td>
			<td style="width:2em;height:4em;"></td>
			<td><div class="content">
			{description} <span class="readMore"><a href="redirect.php?id={id}&url={URL}" target="_blank" onmouseover="JavaScript:windows.status='this link blaber';
           return true;" onmouseout="window.status=''">Read more..</a></span></div></td>
			</tr>

	</table>
</br>
	<span class="readMore"><a href="#" style="font-size:0.7em;" id="{id}_report" onclick="articleAction(this,2,false)">report article</a></span>
	<span class="readMore"><a href="#" style="font-size:0.7em;" id="{id}_report" onclick="articleAction(this,2,false)">report article</a></span>
	
	<div style="height:1px;width:100%;background-color:#c6c6c6;"></div>

	</br>
</div>