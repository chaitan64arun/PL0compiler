#ifndef MYERROR_H
#define MYERROR_H

int myerror(int err) {
  switch (err) {
    case 1: printf("Use of = instead of :=\n");
      break;
    case 2: printf("= must be followed by number\n");
      break;
    case 3: printf("Identifier must be followed by =\n");
      break;
    case 4: printf("const, var, proc must be followed by an identifier \n");
      break;
    case 5: printf("Semicolon or comma missing\n");
      break;
    case 6: printf("Incorrect symbol after procedure declaration\n");
      break;
    case 7: printf("Statement Expected\n");
      break;
    case 8: printf("Incorrect symbol after statement part in block\n");
      break;
    case 9: printf("Period expected\n");
      break;
    case 10: printf("Semicolon between statements is missing\n");
      break;
    case 11: printf("Undeclared identifier\n");
      break;
    case 12: printf("Assignment to constant or procedure not allowed\n");
      break;
    case 13: printf("Assignment operator := expected\n");
      break;
    case 14: printf("Call must be followed by an Identifier\n");
      break;
    case 15: printf("Call of variable or constant is meaningless\n");
      break;
    case 16: printf("Then expected\n");
      break;
    case 17: printf("Semicolon or end expected\n");
      break;
    case 18: printf("do expected\n");
      break;
    case 19: printf("Incorrect symbol following statement\n");
      break;
    case 20: printf("Relational operator expected\n");
      break;
    case 21: printf("Expression must not contain a procedure identifier\n");
      break;
    case 22: printf("Right Parenthesis Missing\n");
      break;
    case 23: printf("The preceeding factor cannot be followed by this symbol\n");
      break;
    case 24: printf("An expression cannot begin with this symbol\n");
      break;
    case 25: printf("Expecting comma between declarations\n");
      break;
    case 30: printf("number out of bound\n");
      break;
    default: printf("Unknown error");
  }
}
#endif
