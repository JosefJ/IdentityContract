function bytesToArray(input) {
    var output = '[';

    for (var i = 2; i < input.length; i += 2) {
        output = output+'"0x' + input[i] + input[i+1] + '",';
    }
    output[output.length-1] = ']';
    return output
}
