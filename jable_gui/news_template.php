<div class="newsTemp"> 
   <p>
       <a href="redirect.php?id={id}&url={URL}" onmouseover="JavaScript:windows.status='this link blaber';
           return true;" onmouseout="window.status=''";><h1>{title}</h1></a>
   </p>
   <p class="main" style="min-height: 90px;">
       <img src="{image}" align="left">
       {description}
   </p>  
</div>
<div style="position: relative; height: 30px; padding-bottom: 30px;">
    <div class="absolute_24x24_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/fatcow/farm-fresh/16/thumb-up-icon.png');left:10px;"
         id="{id}_vote_up" onclick="articleAction(this,1,false)"></div>
    <div class="absolute_24x24_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/fatcow/farm-fresh/16/thumb-down-icon.png');left:40px;"
         id="{id}_vote_down" onclick="articleAction(this,0,false)"></div>
    <div class="absolute_24x24_centerback" 
         style="background-image: URL(img/thumb-up-icon-bw.png);left:10px;display:none;" 
         id="{id}_vote_up_active" onclick="articleAction(this,1,true)"></div>
    <div class="absolute_24x24_centerback" 
         style="background-image: URL(img/thumb-down-icon-bw.png);left:40px;display:none;" 
         id="{id}_vote_down_active" onclick="articleAction(this,0,true)"></div>     
    <div class="absolute_24x24_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/kyo-tux/aeon/16/Sign-Alert-icon.png');right:10px;"
         id="{id}_report" onclick="articleAction(this,2,false)"></div>
    <div class="up_down_div">
       <!-- <span class="up_count_span" id="{id}_count_vote_up">
            {up}
        </span>
        <span class="slash_count_span" id="">
            /
        </span>
        <span class="down_count_span" id="{id}_count_vote_down">
            {down}
        </span>-->
        <div style="background-color:darkred;width:120px; height:5px;">
            <div style="background-color:darkgreen;height:5px;<?php echo 'width:{vote_bar}%;' ?>"></div>
        </div>
    </div>
</div>
 