
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
         style="background-image: url('http://cdn3.iconfinder.com/data/icons/freeapplication/png/24x24/Thumbs%20up.png');left:10px;"
         id="{id}_vote_up" onclick="articleAction(this,1,false)"></div>
    <div class="absolute_24x24_centerback" 
         style="background-image: url('http://cdn3.iconfinder.com/data/icons/freeapplication/png/24x24/Thumbs%20down.png');left:50px;"
         id="{id}_vote_down" onclick="articleAction(this,0,false)"></div>
    <div class="absolute_24x24_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/24/Actions-edit-undo-icon.png');left:30px;display:none;" 
         id="{id}_vote_undo" onclick="articleAction(this,0,true)"></div>
    <div class="absolute_24x24_centerback" 
         style="background-image: url('http://cdn3.iconfinder.com/data/icons/softwaredemo/PNG/24x24/Warning.png');right:10px;"
         id="{id}_report" onclick="articleAction(this,2,false)"></div>
</div>
 