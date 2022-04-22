$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type === "EmlakPasswordMenu"){
            $('.kibra-emlak-password').fadeIn(500);
        } else if(event.data.type === "ClosePasswMenu") {
            $('.kibra-emlak-password').hide();
        } else if(event.data.type === "CloseEmlakMenu") {
            $('.kibra-emlak-managament-menu').hide();
        } else if(event.data.type === "EmlakYonetimPanel") {
            $('.kibra-emlak-managament-menu').fadeIn(500);
            $('#ChangeNamePrice').html(event.data.ChangeNamePrice)
            $('#KasaPara').html(event.data.EmlakPara)
        }
    });
});

$(document).on('click','#LoginPassword',function(e){
    e.preventDefault();
    $(".kibra-emlak-password").hide();
    $.post('http://kibra-emlakv2/PasswordToStash', JSON.stringify({
        Password: $("#PasswordInput").val()
    }));
    $.post('http://kibra-emlakv2/ClosePasswordMenu', JSON.stringify({}));
})

$(document).on('click','#ParaYatir',function(e){
    e.preventDefault();
    $.post('http://kibra-emlakv2/ParaYatir', JSON.stringify({
        KacPara: $("#YatirilanMiktar").val()
    }));
})

$(document).on('click','#ChangePassword',function(e){
    e.preventDefault();
    $.post('http://kibra-emlakv2/EmlakPasswordChange', JSON.stringify({
        Password: $("#OrospuSedaTurkcemiz").val()
    }));
})

$(document).on('click','#ParaCek',function(e){
    e.preventDefault();
    $.post('http://kibra-emlakv2/ParaCek', JSON.stringify({
        KacPara: $("#CekilenMiktar").val()
    }));
})

$(document).on('click','#AklaPara',function(e){
    e.preventDefault();
    $.post('http://kibra-emlakv2/BlackMoneyWash', JSON.stringify({
        KacPara: $("#BlackMoneyCount").val()
    }));
    $.post('http://kibra-emlakv2/CloseEmlakMenu', JSON.stringify({}));
})

$(document).on('click','#ClosePsa',function(e){
    e.preventDefault();
    $.post('http://kibra-emlakv2/ClosePasswordMenu', JSON.stringify({}));
})

$(document).on('click','#EmlakDegistirMenu',function(){
    $(".kibra-emlak-para-islem").hide();
    $(".emlak-ad-degistir").fadeIn(500);
    $(".karapara-akla").hide();
})

$(document).on('click','#SalesHouses',function(e){
    e.preventDefault();
    $.post('http://kibra-emlakv2/CloseEmlakMenu', JSON.stringify({}));
    $.post('http://kibra-emlakv2/OpenSalesHouses', JSON.stringify({}));
})

$(document).on('click','#MainSayfa',function(){
    $(".emlak-ad-degistir").hide();
    $(".karapara-akla").hide();
    $(".kibra-emlak-para-islem").fadeIn(500);
})

$(document).on('click','#BlackMoneyWash',function(){
    $(".emlak-ad-degistir").hide();
    $(".kibra-emlak-para-islem").hide();
    $(".karapara-akla").fadeIn(500);
})

$(document).on('click','#ChangeNameEmlaq',function(e){
    e.preventDefault();
    $(".kibra-emlak-password").hide();
    $.post('http://kibra-emlakv2/ChangeNameEmlak', JSON.stringify({
        EmlakName: $("#OrospuSeda").val()
    }));
    $.post('http://kibra-emlakv2/CloseEmlakMenu', JSON.stringify({}));
})

document.onkeyup = function(data){
    if (data.which == 27){
        $('.kibra-emlak-managament-menu').fadeOut(500);
        $.post('http://kibra-emlakv2/CloseEmlakMenu', JSON.stringify({}));
    }
}