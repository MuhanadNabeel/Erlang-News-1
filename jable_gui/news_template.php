
<div class="newsTemp"> 
   <p>
       <h1>{title}</h1>
   </p>

   <p class="main">
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
         style="background-image: url('http://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/24/Actions-edit-undo-icon.png');left:30px;display:none;" 
         id="{id}_vote_undo" onclick="articleAction(this,0,true)"></div>
    <div class="absolute_24x24_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/kyo-tux/aeon/16/Sign-Alert-icon.png');right:10px;"
         id="{id}_report" onclick="articleAction(this,2,false)"></div>
</div>
 