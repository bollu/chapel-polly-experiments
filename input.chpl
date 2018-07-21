module matrix_multiplication {
  proc test(A:[0..1,0..1] real){
    for i in 0..1{
      for j in 0..1{
        A(i,j) = 10;
      }
    }
  }

  proc main(){
    var A:[0..1,0..1] real;
    writeln ("array(BEFORE):\n", A);
    test(A);

    writeln ("array(AFTER):\n", A);
  }
}

