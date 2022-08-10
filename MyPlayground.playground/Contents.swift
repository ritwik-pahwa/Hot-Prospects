import UIKit

func change(_ number: inout Int){
    number = 2
}
var number = 1
change(number)
print(number)
