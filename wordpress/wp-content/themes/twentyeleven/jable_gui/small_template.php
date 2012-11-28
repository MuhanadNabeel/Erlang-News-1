<li style="margin-bottom:10px;">
	<table style="border:solid 1px rgba(0,0,0,0.2);width:100%;padding-top:0px;padding:5px;">
		<tr>
			<td>
				<table style="width:100%;">
					<td style="white-space:nowrap;float:left;">
						<div style="vertical-align:middle;">
							<img src="{icon}" style="height:12px;width:12px;margin-top:6px;margin-right:0px;visibility:<?php echo '{icon_hide}'; ?>;">
							<div style="font-family:'Times New Roman';font-style:italic;font-size:6pt;color:rgba(0,0,0,0.4)">Published: {pubdate}</div>
						</div>
					</td>
					<td style="white-space:nowrap;float:right">
						<div>
							<span class="readMore" style="font-size:8pt;">
								<a style="cursor:pointer;color:#b9b9b9" id="{location}_{id}_{action2}" onclick="articleAction(this,2,false);fadeWindow('{id}_reported_window', 'reported!');">report article</a>
								<a style="cursor:pointer;display:none;color:#b20000" id="{location}_{id}_{action2}_active" onclick="articleAction(this,2,true);fadeWindow('{id}_reported_window', 'unreported!');">unreport article</a>
								<div class="window" id="{id}_reported_window" style="margin-top:-40px;"><div id="{id}_reported_window_text"></div>
							</span>
						</div>
					</td>
				</table>
			</td>
		</tr>
		

		<tr>
			<td>

				<div style="line-height:120%;font-face:'arial';font-weight:bold;margin-bottom:10px;cursor:pointer;" onclick="openBox(<?php echo '{id},{index}' ?>);">{title}</div>
			</td>
		</tr>


		<tr>
			<td>
				<div style="line-height:120%;font-family:'MyriadPro regular';font-size:10pt;margin-bottom:20px;">{description}</div>
			</td>
		</tr>


		<tr>
			<td>
				<table style="width:100%;">
					<tr>
						<td style="float:left;">
							<span class="right_source" style="font-size:8pt;"> 
						        <a onclick="openBox(<?php echo '{id},{index}' ?>)" style="font-size:8pt;cursor:pointer;">{host}</a>
						    </span>
						</td>
						<td style="float:right;">
							<table>
								<td>
									<div >
									<table style="margin-right:13px;">
										<tr>
											<td>
												<div class="thumb-up" id="{location}_{id}_{action1}" onclick="articleAction(this,1,false)" align="center" style="">
													<a id="{location}_{id}_{action1}_count" class="likes" style="float:left;margin-left:-13px;margin-top:3px">{up}</a>
												</div>
												<div class="thumb-up-active" id="{location}_{id}_{action1}_active" onclick="articleAction(this,1,true)" align="center">
													<a id="{location}_{id}_{action1}_count_active" class="likes" style="float:left;margin-left:-13px;margin-top:3px">{up}</a>
												</div>
											</td>
											<td>
												<div class="thumb-down" id="{location}_{id}_{action0}" onclick="articleAction(this,0,false)" align="center">
													<a id="{location}_{id}_{action0}_count" class="likes" style="float:right;margin-right:-13px;margin-top:3px">{down}</a>
												</div>
												<div class="thumb-down-active" id="{location}_{id}_{action0}_active" onclick="articleAction(this,0,true)" align="center">
													<a id="{location}_{id}_{action0}_count_active" class="likes" style="float:right;margin-right:-13px;margin-top:3px">{down}</a>
												</div>
											</td>
										</tr>
									</table>
									</div>
								</td>
							</table>

						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</li>