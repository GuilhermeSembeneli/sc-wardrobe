'use strict';
$('body').hide();
String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.substr(1);
}
let boxcontainer = $('.sc-container-itens ')
let button = $('.sc-button-vestir')

let policia = [ "soldado", "recruta", "soldado"]
let paramedico = [ "paramedico", "medico"]

$(document).ready(function() {
    window.addEventListener('message', event => {
        let events = event.data
        let _try = events.ped == 'female' ? 'mulher' : 'homem'
        if (events.send == 'open') Open()
        if (events.send == 'closed') Closed()

        
        if (events.ped && events.GetPerm == 'Policia') {
            SetText(policia)
            SetClothes(policia)
        }
                            
        if (events.ped && events.GetPerm == 'Paramedico') {
            SetText(paramedico)
            SetClothes(paramedico)
        }

    
        function SetText(namesetgroup){
            for (var i = 0; i < namesetgroup.length; i++) {
                $(boxcontainer).append(`
                <div class="sc-box-clothes  ${namesetgroup[i]}" >
                    <div class="sc-just-text" >
                    <p>${namesetgroup[i].capitalize() }</p>
                    <p>${_try.capitalize()}</p>
                    </div>
                    <img src="img/${_try}/${namesetgroup[i]}.png" class="sc-image" >
                </div>
                `);
            }
        }
        function AddClassButton(_this) {
            $(`.sc-box-clothes`).removeClass('active');
            $(_this).addClass('active');
            $('.sc-button-vestir').html(`
                <button class="sc-vestir hover">Vestir</button>
            `)
        }
        function SetNameClothes(nameset){
            $('.sc-vestir').click(function (e) {
                _post('Fards', { clothes: `${nameset}`});
            })
        }

        function SetClothes(nameset){
            nameset.forEach(e => {
                SetClothe(e)
            });
        }

        function SetClothe(nameset){
            $(`.${nameset}`).click(function (e) {
                AddClassButton(this)
                SetNameClothes(nameset)
            });
        }

        function Closed() { 
            $('body').fadeOut('slow');
            boxcontainer.empty()
            button.empty()
        }

        function Open() { 
            $('body').fadeIn('slow') 
            $('.sc-button-vestir').html(`
                <button class="sc-vestir" disabled>Vestir</button>
            `)
         }
    });
});

$('.retirar').click(function (e) {
    _post("Remove")
 });

document.onkeyup = function (data) {
    if (data.which == 27) {
        _post('closed')
    }
}

let _post = function (event, d, cb) {
    $.post(`https://sc-wardrobe/${event}`, JSON.stringify((d === undefined) ? {} : d), (cb === undefined) ? () => { } : cb);
}
