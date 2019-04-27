%{
  #include<iostream>
  #include<vector>
  #include<set>
  #include <string>
  using namespace std;

  struct _word{
    string lexeme;
    string category;
    string line;
  };

  vector<struct _word> _words;
  vector<int> _indents;
  set<string> _ids;
  bool  _error = false;

  void _save_word(string lexeme, string category){
    struct _word word = {
        .lexeme = lexeme, .category = category
    };
    _words.push_back(word);
  }
  void _save_word_igonore_newline(string lexeme, string category){
    if(_words[_words.size()-1].category == "NEWLINE"){

    }else{
      struct _word word = {
          .lexeme = lexeme, .category = category
      };
        _words.push_back(word);
    }
  }
%}

%option noyywrap
%option yylineno


%%

"if"  {        _save_word(yytext,"IF");             }
"else"  {      _save_word(yytext,"ELSE");           }
":"   {        _save_word(yytext,"COLON");          }
"True"  {      _save_word("1","BOOLEAN");              }
"False" {      _save_word("0","BOOLEAN");              }
","   {        _save_word(yytext,"COMMA");          }
"return"  {    _save_word(yytext,"RETURN");         }
"def"     {   _save_word(yytext,"DEF");             }
"and"   {        _save_word(yytext,"AND");          }
"break"   {        _save_word(yytext,"BREAK");          }
"elif"  {        _save_word(yytext,"ELIF");          }
"for"   {        _save_word(yytext,"FOR");          }
"not"   {        _save_word(yytext,"NOT");          }
"or"  {        _save_word(yytext,"OR");          }
"while"   {        _save_word(yytext,"WHILE");          }


#(.*)?(\n) { }


[a-zA-Z] {
          _save_word(yytext,"IDENTIFIER");
}
[a-zA-Z]+[^ \t\n(:),.;]*  {
          _save_word(yytext,"IDENTIFIER");
}

[0-9]+   {
          _save_word(yytext,"INTEGER");
}
[0-9]+("."[0-9]+) {
          _save_word(yytext, "FLOAT");
}

"="   {        _save_word(yytext, "ASSIGN");  }
"=="  {       _save_word(yytext, "EQ");     }
"!="  {       _save_word(yytext, "NEQ");    }
">="  {        _save_word(yytext, "GTE");     }
"<="  {       _save_word(yytext,"LTE");     }
"-"   {       _save_word(yytext, "MINUS");     }
"*"   {        _save_word(yytext, "TIMES");         }
"\n"  {        _save_word_igonore_newline(" ","NEWLINE");    }
"/"   {        _save_word(yytext, "DIVIDEDBY ");     }
"("   {        _save_word(yytext,"LPAREN");         }
")"   {        _save_word(yytext,"RPAREN");         }
">"   {        _save_word(yytext,"GT");             }
"<"   {        _save_word(yytext,"LT");             }
"+"   {        _save_word(yytext,"PLUS");              }
" "   {        _save_word(" ", "Space");   }
"\t"  {        _save_word(" ", "Table");}

<<EOF>> {
        if(_error){
          return 1;
        }else{
          return 0;
        }
}

%%

int main(){
  _indents.push_back(0); // indent start from 0;
  if(!yylex()){
      int num = 0;
      for(int i = 0; i < _words.size();i++){
        if(_words[i].category == "FLOAT"){
            cout << _words[i].category << "\t\t" << _words[i].lexeme << endl;
        }else if(_words[i].category == "NEWLINE"){
            cout << _words[i].category << "\t\t" << _words[i].lexeme << endl;
            int num_dent = 0;
            if( i < _words.size()-1 && _words[i+1].category == "Space"){
                  int loop = 0;
                  while(loop < 1){
                    i = i + 1;
                    num_dent = num_dent + 1; // get the number of space;
                    if(_words[i+1].category != "Space"){
                      loop = 2;
                    }
                  }
                  if(num_dent == 0 && _indents.size() > 1){ // if number of space is 0, and _indents.size() > 1; pop out all
                      for(int k = 1; k < _indents.size(); k ++){
                        //cout <<"The size of _indents: " << _indents.size() << endl;
                        cout << "DEDENT" << "\t\t" << endl;
                        //_indents.pop_back();
                      }
                      _indents.clear();
                      _indents.push_back(0);
                  }else if(num_dent < _indents[_indents.size() -1]){ // means dedent
                      int loop1 = 0;
                      while(loop1< 1){
                          if(num_dent !=_indents[_indents.size() -1] ){
                              //cout << "num_dent: " << num_dent << "_indents[_indents.size() -1]: " <<_indents[_indents.size() -1]<< endl;
                              cout << "DEDENT" << "\t\t" << endl;
                              _indents.pop_back();
                          }else{
                              loop1 = 2;
                          }
                      }
                  }else if(num_dent > _indents[_indents.size()-1]){ // mean indent

                      cout << "INDENT" << "\t\t"<<"" <<endl;
                      _indents.push_back(num_dent);
                  }else{
                    //  cout << "UNKNOEN !!!!!!!!!!!!!!!!!!!!!" << endl;
                  }
            }else if(i == _words.size()-1){ // if newline is the last;
                if(_indents.size() == 1){
                }else{
                  for( int k = 1; k < _indents.size(); k++){
                      //cout <<"The size of _indents: " << _indents.size() << endl;
                      cout << "DEDENT" << "\t\t" << "" << endl;
                      //_indents.pop_back();
                  }
                  _indents.clear();
                  _indents.push_back(0);
                }
            }else{
                num_dent = 0;
                for(int k = 1; k < _indents.size(); k ++){
                  //cout <<"The size of _indents: " << _indents.size() << endl;
                  cout << "DEDENT" << "\t\t" << endl;
                  //_indents.pop_back();
                }
                _indents.clear();
                _indents.push_back(0);
            }
          //  cout << "number: " << num_dent << endl;
        }else if(_words[i].category == "Space"){
        }else{
            cout << _words[i].category << "\t\t" << _words[i].lexeme << endl;
          }
      }
  }
/*
  for( int i = 0; i < _indents.size();i ++){
      cout << _indents[i] << endl;
  }*/
  return 0;
}
