//Getting display element

const display = document.getElementById('display');

//functions for calculator operations
function appendToDisplay(input) {
    display.value += input;
}

function clearDisplay() {
    display.value = '';
}

function calculate() {
    try{
        display.value = eval(display.value);
    }
    catch(error){
        display.value = 'Error';
    }
}