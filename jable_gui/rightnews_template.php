<div class="right_recent">
    <a href="">{title}</a>
    <div style="position: relative; height: 30px;">
    <div class="absolute_16x16_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/fatcow/farm-fresh/16/thumb-up-icon.png');left:10px;"
         id="{id}_vote_up" onclick="articleAction(this,1,false)"></div>
    <div class="absolute_16x16_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/fatcow/farm-fresh/16/thumb-down-icon.png');left:50px;"
         id="{id}_vote_down" onclick="articleAction(this,0,false)"></div>
    <div class="absolute_16x16_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/24/Actions-edit-undo-icon.png');left:30px;display:none;" 
         id="{id}_vote_undo" onclick="articleAction(this,0,true)"></div>
    <div class="absolute_16x16_centerback" 
         style="background-image: url('http://icons.iconarchive.com/icons/kyo-tux/aeon/16/Sign-Alert-icon.png');left:90px;"
         id="{id}_report" onclick="articleAction(this,2,false)"></div>
</div>
</div>