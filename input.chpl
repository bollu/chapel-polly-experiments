module matrix_multiplication {
  proc test(A:[0..4,0..4] real){
    for i in 0..4{
      for j in 0..4{
        A(i,j) = 40;
      }
    }
  }

  proc main(){
    var A:[0..4,0..4] real;
    writeln ("array(BEFORE):\n", A);
    test(A);

    writeln ("array(AFTER):\n", A);
  }
}

