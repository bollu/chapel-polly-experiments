module matrix_multiplication {
  proc test(A:[0..5,0..5] real){
    for i in 0..5{
      for j in 0..5{
        A(i,j) = 10;
      }
    }
  }

  proc main(){
    var A:[0..5,0..5] real;
    test(A);
  }
}

