<script type="text/javascript">


	jQuery(document).ready(function() {
		var bodyheight = jQuery(document).height();
		jQuery("#content-div").height(bodyheight);
	});

	// for the window resize
	jQuery(window).resize(function() {
		var bodyheight = jQuery(document).height();
		jQuery("#content-div").height(bodyheight);
	});

	function test(id){
			// since 2.8 ajaxurl is always defined in the admin header and points to admin-ajax.php
			var r=confirm("Are you sure you want to delete?");
			if (r==true){
				var data = {query: "DELETE FROM ernews_news WHERE newsID=",
							newsID: id};
				jQuery.post('http://localhost:8888/wp-content/plugins/jable/_db-handler.php', data, function(response) {
					jQuery("#"+id+"-top").hide();
					jQuery("#"+id+"-bottom").hide();
				});
				jQuery("#"+id+"-top").hide();
				jQuery("#"+id+"-bottom").hide();
			} else{

			}
			
    }

    function edit(id){
    	if (jQuery("#"+id+"-edit").html() != "Save") {
    //		alert(jQuery("#"+id+"-link").html());
    		jQuery("#"+id+"-edit").html("Save");
    		jQuery("#"+id+"-reset").fadeIn('fast');
    		show(id+"-delete");
    		show(id+"-cancel");
    		show(id+"-title");
			show(id+"-titleEdit");
			show(id+"-description");
			show(id+"-descriptionEdit");
			show(id+"-link");
			show(id+"-linkEdit");
			
    	}else if(jQuery("#"+id+"-edit").html() == "Save"){
    		var data = {query: "UPDATE ernews_news SET URL='"+jQuery("#"+id+"-linkEdit").val().replace("'", "").replace("'", "")+"', Description='"+jQuery("#"+id+"-descriptionEdit").val()+"', Title='"+jQuery("#"+id+"-titleEdit").val()+"'	WHERE newsID=",
						newsID: id};

			jQuery.post('http://localhost:8888/wp-content/plugins/jable/_db-handler.php', data, function(response) {
				jQuery("#"+id+"-description").html(jQuery("#"+id+"-descriptionEdit").val());
				jQuery("#"+id+"-title").html(jQuery("#"+id+"-titleEdit").val());
				jQuery("#"+id+"-link").html("<a href='"+ jQuery("#"+id+"-linkEdit").val()+ "' target='_blank'>Link</a>");
			});
			cancel(id);
    	}
    }

    function cancel(id){
    	jQuery("#"+id+"-edit").html("Edit");
    	jQuery("#"+id+"-reset").fadeOut('fast');
    	show(id+"-delete");
		show(id+"-cancel");
		show(id+"-title");
		show(id+"-titleEdit");
		show(id+"-description");
		show(id+"-descriptionEdit");
		show(id+"-link");
		show(id+"-linkEdit");
		
    }

    function show(id){
    	if(jQuery("#"+id).css("display") != "block"){
    		jQuery("#"+id).fadeIn('fast').css("display", "block");
    	//	jQuery("#"+id).css("display", "block");	
    	}else{
    		jQuery("#"+id).css("display", "none");	
    	}
    	
    }

</script>

<div class="wrap">  
	<?php    echo "<h2>" . __( 'Edit articles' ) . "</h2>"; ?>
	<table style="width:100%;">
		<td style="vertical-align:top; width:60%;">
		<table class="widefat">
		<thead>
		<tr>
		        <th style='width:13%;'>Stats</th>
		        <th style='width:4%;'>URL</th>
			<th style='width:11.3%;'>Title</th>
			<th style='width:;'>Description</th>
			<th style='width:5%;'>Edit</th>
		</tr>
		</thead>
		</table>
		<div id="content-div" style="overflow:scroll;height:1px;">
		<table class="widefat" cellspacing="0">
			
				<?php
					echo "
					";
					include "MySQL.php";

					$sql = new MySQL();
					$result = $sql -> sqlQuery("SELECT * FROM ernews_news ORDER BY Report_Count DESC");
					echo "<tbody>";
					while(($row = mysql_fetch_array($result)) !== false){
												
						echo "<tr id='". $row['newsID'] ."-top'>
						<td style='color:gray;'>Stats</td>
						<td style='color:gray;'>URL</td>
						<td style='color:gray;'>Title</td>
						<td style='color:gray;'>Description</td>
						<td style='color:gray;'></td>
						</tr>";


						if($row['Report_Count']>4){
							echo "<tr id='". $row['newsID'] ."-bottom' style='background-color:#f8d4d5;'>";
						}else{
							echo "<tr id='". $row['newsID'] ."-bottom'>";
						}	
						echo "<td nowrap>
						Uploaded: <b>". current(explode(' ', $row['TimeStamp'])) ."</b></br>
						Published: <b>". current(explode(' ', $row['Pubdate'])) ."</b></br>
						<b>". $row['Clicks'] ."</b> clicks </br>
						<b>". $row['Report_Count'] ."</b> reports</br>
						<b>0</b> comments</br>
						<b>". $row['Up_Vote'] ."</b> likes</br>
						<b>". $row['Down_Vote'] ."</b> dislikes</br>
						</td>

						<td><div id='". $row['newsID'] ."-link'><a href='" . $row['URL'] . "' target='_blank'>Link</a></div>
						<textarea id='". $row['newsID'] ."-linkEdit' style='display:none;resize: none; height:100% width:100%;border-radius:4px;'>'" . $row['URL'] . "'</textarea>
						</td>
						

						<td><div id='". $row['newsID'] ."-title'>". $row['Title'] ."</div>
						<textarea id='". $row['newsID'] ."-titleEdit' style='display:none; height:100%;width:100%;resize: none; border-radius:4px;'>". $row['Title'] ."</textarea></td>
						<td><div id='". $row['newsID'] ."-description'>". $row['Description'] ."</div>
						<textarea id='". $row['newsID'] ."-descriptionEdit' style='display:none;height:100%;width:100%;resize:none;border-radius:4px;'>". $row['Description'] ."</textarea></td>
						

						<td><button id='". $row['newsID'] ."-edit' class='button' onclick='edit(". $row['newsID'] .")'>Edit</button></div>
							<button id='". $row['newsID'] ."-cancel' style='display:none;' class='button' onclick='cancel(".$row['newsID'].")'>Cancel</button></div>
							<button id='". $row['newsID'] ."-delete' style='display:none;' class='button' onclick='test(". $row['newsID'] .")'>Delete</button></div></td>
						</tr>";




					};
					echo "</tbody>";
				?>
			</tbody>
		</table>
		</div>
		</td>
		<td style="vertical-align:top; width:40%;">
		

		<?php include "statistics.php"?>



		</td>
	</table>
	

</div>