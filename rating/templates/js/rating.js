
var Rat = new Object({
    up:function(id,type,elem)
    {
        $.post('/rating/up',{item_id:id,type:type},function(data){
            switch (parseInt(data)) {
                case 1:
                    var result = parseInt($(elem).prev().text()) + 1;
                    $(elem).prev().text(result);
                    if(result>0)
                        {
                            $(elem).prev().addClass('green');
                        }
                    else if(result<0)
                        {
                            $(elem).prev().addClass('red');
                        }
                    else {
                        $(elem).prev().removeClass();
                    }
                    break;
                case 2:
                    break;
                case 3:
                    alert('Вы уже голосовали!');
                    break;
            }
        });
    },
    down:function(id,type,elem)
    {
        $.post('/rating/down',{item_id:id,type:type},function(data){
            switch (parseInt(data)) {
                case 1:
                    var result = parseInt($(elem).next().text())-1;
                    $(elem).next().text(result);
                    if(result>0)
                        {
                            $(elem).next().addClass('green');
                        }
                    else if(result<0)
                        {
                            $(elem).next().addClass('red');
                        }
                    else {
                        $(elem).next().removeClass();
                    }
                    break;
                case 2:
                    break;
                case 3:
                    alert('Вы уже голосовали!');
                    break;
            }
        });
    }
});