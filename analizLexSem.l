%{
  /*
    Garcia Aguilar Ricardo Daniel
    Ortega Vazquez Luis Alberto
    Compiladores
    Profesora: Laura Sandoval Montaño
    Descripcion:
      Identificar los diferentes componentes del lenguaje definido en clase
  */

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  //Longitud maxima de cada simbolo perteneciente a una tabla de operadores
  #define LONG_MAX_SYM 20
  #define LONG_MAX_PALRES 12
  #define LONG_MAX_STR 10

  //Total de simbolos en cada tabla de operador
  #define SIMB_REL_NUM 6
  #define SIMB_ASIG_NUM 1
  #define SIMB_ARIT_NUM 4
  #define SIMB_ESP_NUM 6
  #define SIMB_PALRES_NUM 15

  //Simbolos de palabras reservadas
  #define SIMB_PALRES {"_corto", "_desde", "_entero", "_findesde", "_finmientras", "_finsi", "_hasta", "_haz", "_incremento", "_largo", "_mientras", "_real", "_si", "_simbolo", "_sino"}
  //Simbolos de cada tabla de operadores
  #define SIMB_REL { ">", ">=", "<", "<=", "=", "><" }
  #define SIMB_ASIG { ":=" }
  #define SIMB_ARIT { "+", "-", "*", "/"}
  //Simbolos especiales
  #define SIMB_ESP {  ",", ".", "(", ")", "[", "]" }

  //Funcion encargada de encontrar una palabra (symb) en un arreglo (arr) de tamanio dado (tam)
  int buscaElemento(const char **arr, char *symb, char tam);

  //Estructura que almacena los diferentes operadores un arreglos distintos
  typedef struct{
    const char *palRes[SIMB_PALRES_NUM];
    const char *opRel[SIMB_REL_NUM];
    const char *opAsig[SIMB_ASIG_NUM];
    const char *opArit[SIMB_ARIT_NUM];
    const char *simbEsp[SIMB_ESP_NUM];
  }Operadores;

  //Estructura de lista ligada TOKENS
  struct nodoLista{
    char clase;
    char posicion;
    struct nodoLista *ptrSig;
  };

  typedef struct nodoLista NodoLista;
  typedef NodoLista *ptrNodoLista;

  //Estructura de lista ligada TOKENS
  struct nodoListaExpandible{
    char elemento[20];
    char clase;
    struct nodoListaExpandible *ptrSig;
  };

  typedef struct nodoListaExpandible NodoListaExpandible;
  typedef NodoListaExpandible *ptrNodoListaExpandible;

  //Estructura de lista ligada cadena de atomos
  struct nodoListaAtomos{
    char atomo;
    struct nodoListaAtomos *ptrSig;
  };

  typedef struct nodoListaAtomos NodoListaAtomos;
  typedef NodoListaAtomos *ptrNodoListaAtomos;

  //Funciones para el manejo de la lista ligada TOKENS
  void insertarToken( ptrNodoLista *ptrS, char clase, char posicion);
  void imprimeListaToken( ptrNodoLista ptrActual );

  //Funciones para el manejo de la lista ligada EXPANDIBLE
  void insertar( ptrNodoListaExpandible *ptrS, char *elemento, char clase);
  void imprimeLista( ptrNodoListaExpandible ptrActual );

  //Funciones para el manejo de la lista ligada de la cadena de ATOMOS
  void insertarAtomo( ptrNodoListaAtomos *ptrS, char elemento);
  void imprimeListaAtomos( ptrNodoListaAtomos ptrActual );

  //Funciones que pasan los elementos de la lista a archivos
  void lista2ArchivoToken(ptrNodoLista ptrInicial, FILE *fp);
  void lista2ArchivoToken2(ptrNodoListaExpandible ptrActual, FILE *fp);
  void lista2Archivo(ptrNodoListaExpandible ptrInicial, char *titulo, FILE *fp);
  void lista2ArchivoAtomos(ptrNodoListaAtomos ptrInicial, char *titulo, FILE *fp);

  char decodificadorAtomos(char *string);
  char comparaCadenas(char *s1, char *s2);
  void error(char *s, FILE *fp);

  int i, j;
  Operadores op = { SIMB_PALRES, SIMB_REL, SIMB_ASIG, SIMB_ARIT, SIMB_ESP};  //Se inicializa las tablas de operadores

  //Archivo de salida
  FILE *archSalida;

  char c[16];
  char s;
  char berror = 0;

  //Estructuras donde se almacenaran las cadenas una vez identificadas
  ptrNodoLista ptrInicialTokens = NULL;
  ptrNodoListaExpandible ptrInicialIden = NULL;
  ptrNodoListaExpandible ptrInicialCad = NULL;
  ptrNodoListaExpandible ptrInicialConstEnt = NULL;
  ptrNodoListaExpandible ptrInicialConstReal = NULL;
  ptrNodoListaExpandible ptrInicialError = NULL;
  ptrNodoListaExpandible ptrInicialErrorSem = NULL;
  ptrNodoListaExpandible ptrInicialProd = NULL;
  ptrNodoListaAtomos ptrInicialAtomos = NULL;
  ptrNodoListaAtomos ptrInicialAtomos2 = NULL;

  //Funciones del analizador SINTACTICO
  void getNextChar();
  void S();
  void D();
  void DP();
  void TBP();
  void N();
  void B();
  void J();
  void L();
  void P();
  void Z();
  void PP();
  void M();
  void H();
  void I();
  void G();
  void FP();
  void A();
  void R();
  void O();
  void E();
  void EP();
  void T();
  void TP();
  void F();
  void Parser();
%}
palRes     _corto|_desde|_entero|_findesde|_finmientras|_finsi|_hasta|_haz|_incremento|_largo|_mientras|_real|_si|_simbolo|_sino
ident      [a-zA-Z]{1,16}
opAsig     :=
opRel      >=?|<=?|><|=
opArit     [\+\-*\/]
simbEsp    [\.,\(\)\[\]]
consCad    \".*\"
signo      [\+\-]
consEnt    [0-9]+
sufijo     E{consEnt}
consReal   ({consEnt}?\.[0-9]+{sufijo}?)|({consEnt}\.{sufijo}?)
comentario ¡.*!
espacio    [ \n\t]+
error      [_:#$%&;{}?¿\\]+
%%
{palRes}      j = buscaElemento(op.palRes, yytext, SIMB_PALRES_NUM); insertarToken(&ptrInicialTokens, 0, j); insertarAtomo(&ptrInicialAtomos, decodificadorAtomos(yytext));
{ident}       insertar(&ptrInicialIden, yytext, 1); insertarAtomo(&ptrInicialAtomos, 'a');
{opAsig}      j = buscaElemento(op.opAsig, yytext, SIMB_ASIG_NUM); insertarToken(&ptrInicialTokens, 2, j); insertarAtomo(&ptrInicialAtomos, '=');
{opRel}       j = buscaElemento(op.opRel, yytext, SIMB_REL_NUM); insertarToken(&ptrInicialTokens, 3, j); insertarAtomo(&ptrInicialAtomos, decodificadorAtomos(yytext));
{opArit}      j = buscaElemento(op.opArit, yytext, SIMB_ARIT_NUM); insertarToken(&ptrInicialTokens, 4, j); insertarAtomo(&ptrInicialAtomos, yytext[0]);
{simbEsp}     j = buscaElemento(op.simbEsp, yytext, SIMB_ESP_NUM); insertarToken(&ptrInicialTokens, 5, j); insertarAtomo(&ptrInicialAtomos, yytext[0]);
{consCad}     insertar(&ptrInicialCad,yytext, 6); insertarAtomo(&ptrInicialAtomos, 'y');
{consEnt}     insertar(&ptrInicialConstEnt,yytext, 7); insertarAtomo(&ptrInicialAtomos, 'x');
{sufijo}
{consReal}    insertar(&ptrInicialConstReal,yytext, 8); insertarAtomo(&ptrInicialAtomos, 'z');
{comentario}
{error}       insertar(&ptrInicialError,yytext, 9);
{espacio}
%%
int main(int argc, char *argv[]){
  archSalida = fopen("Salida.txt", "w");

  yyin = fopen(argv[1], "r");
  yylex();
  fclose(yyin);

  fprintf(archSalida, "TABLAS GENERADAS:\n\n");
  lista2Archivo(ptrInicialIden, "Tabla de simbolos", archSalida);
  lista2Archivo(ptrInicialCad, "Tabla de Cadenas", archSalida);
  lista2Archivo(ptrInicialConstEnt, "Tabla de Constantes enteras", archSalida);
  lista2Archivo(ptrInicialConstReal, "Tabla de Constantes reales", archSalida);

  fprintf(archSalida, "TOKENS GENERADOS:\n\n");
  lista2ArchivoToken(ptrInicialTokens, archSalida);
  lista2ArchivoToken2(ptrInicialIden, archSalida);
  lista2ArchivoToken2(ptrInicialCad, archSalida);
  lista2ArchivoToken2(ptrInicialConstEnt, archSalida);
  lista2ArchivoToken2(ptrInicialConstReal, archSalida);

  insertarAtomo(&ptrInicialAtomos, '?');  //Se inserta fin de cadena
  ptrInicialAtomos2 = ptrInicialAtomos;
  fprintf(archSalida, "CADENA DE ATOMOS:\n\n");
  lista2ArchivoAtomos(ptrInicialAtomos, "", archSalida);

  Parser(ptrInicialAtomos2);

  fprintf(archSalida, "PRODUCCIONES USADAS:\n");
  lista2Archivo(ptrInicialProd, "", archSalida);

  fprintf(archSalida, "ERRORES GENERADOS:\n\n");
  lista2Archivo(ptrInicialError, "Errores lexicos:", archSalida);
  lista2Archivo(ptrInicialErrorSem, "Errores semanticos:\n", archSalida);

  fclose(archSalida);

  return 0;
}

//Buscar un elemento en una tabla estatica
int buscaElemento(const char **arr, char *symb, char tam){
  char i;
  for (i = 0; i < tam; i++){
    if(strncmp(arr[i], symb, LONG_MAX_SYM) == 0)
      return i;
  }
  return -1;
}

//Regresa el simbolo de una tabla estatica dada una posicion
char* regresaSimbolo(const char **arr, char posicion){
    return arr[posicion];
}

char decodificadorAtomos(char *string){
  if(strncmp(string, "_corto", LONG_MAX_SYM) == 0){
    return 'c';
  } else if(strncmp(string, "_desde", LONG_MAX_SYM) == 0){
    return 'd';
  } else if(strncmp(string, "_entero", LONG_MAX_SYM) == 0){
    return 'e';
  } else if(strncmp(string, "_finmientras", LONG_MAX_SYM) == 0){
    return 'f';
  } else if(strncmp(string, "_finsi", LONG_MAX_SYM) == 0){
    return 'b';
  } else if(strncmp(string, "_hasta", LONG_MAX_SYM) == 0){
    return 't';
  } else if(strncmp(string, "_haz", LONG_MAX_SYM) == 0){
    return 'h';
  } else if(strncmp(string, "_incremento", LONG_MAX_SYM) == 0){
    return 'p';
  } else if(strncmp(string, "_largo", LONG_MAX_SYM) == 0){
    return 'l';
  } else if(strncmp(string, "_mientras", LONG_MAX_SYM) == 0){
    return 'm';
  } else if(strncmp(string, "_real", LONG_MAX_SYM) == 0){
    return 'r';
  } else if(strncmp(string, "_si", LONG_MAX_SYM) == 0){
    return 'i';
  } else if(strncmp(string, "_simbolo", LONG_MAX_SYM) == 0){
    return 's';
  } else if(strncmp(string, "_sino", LONG_MAX_SYM) == 0){
    return 'n';
  } else if(strncmp(string, "_findesde", LONG_MAX_SYM) == 0){
    return 'g';
  } else if(strncmp(string, ">", LONG_MAX_SYM) == 0){
    return 'j';
  } else if(strncmp(string, ">=", LONG_MAX_SYM) == 0){
    return 'k';
  } else if(strncmp(string, "<", LONG_MAX_SYM) == 0){
    return 'q';
  } else if(strncmp(string, "<=", LONG_MAX_SYM) == 0){
    return 'u';
  } else if(strncmp(string, "=", LONG_MAX_SYM) == 0){
    return 'v';
  } else if(strncmp(string, "><", LONG_MAX_SYM) == 0){
    return 'w';
  }
  else{
    return '_';
  }
}

//Insertar cadena en la lista de tokens para cadenas que pertenecen a una tabla estatica
void insertarToken( ptrNodoLista *ptrS, char clase, char posicion){
  ptrNodoLista ptrNuevo;
  ptrNodoLista ptrAnterior;
  ptrNodoLista ptrActual;

  ptrNuevo = malloc(sizeof(NodoLista));

  if( ptrNuevo != NULL ){
    ptrNuevo->clase = clase;
    ptrNuevo->posicion = posicion;
    ptrNuevo->ptrSig = NULL;

    ptrAnterior = NULL;
    ptrActual = *ptrS;

    while( ptrActual != NULL ){
      ptrAnterior = ptrActual;
      ptrActual = ptrActual->ptrSig;
    }

    if ( ptrAnterior == NULL ){
      ptrNuevo->ptrSig = *ptrS;
      *ptrS = ptrNuevo;
    }
    else{
      ptrAnterior->ptrSig = ptrNuevo;
      ptrNuevo->ptrSig = ptrActual;
    }
  }
  else{
    printf("No se inserto el valor\n");
  }
}

void imprimeListaToken( ptrNodoLista ptrActual ){
  char *tmp;

  if ( ptrActual == NULL) {
    printf("La lista esta vacia\n");
  }
  else{
    printf("\nTokens:\n");
    while(ptrActual != NULL){
      if(ptrActual->clase == 4 || ptrActual->clase == 5){
        if(ptrActual->clase == 4){
          tmp = regresaSimbolo(op.opArit, ptrActual->posicion);
          printf("(%d, %c)\n", (ptrActual->clase), tmp[0] );
        }
        else{
          tmp = regresaSimbolo(op.simbEsp, ptrActual->posicion);
          printf("(%d, %c)\n", (ptrActual->clase), tmp[0] );
        }
      }
      else
        printf("(%d, %d)\n", (ptrActual->clase), (ptrActual->posicion) );
      ptrActual = ptrActual->ptrSig;
    }
    printf("NULL\n");
  }
}

//Inserta cadenas en la lista dinamica generada por el analizador
void insertar( ptrNodoListaExpandible *ptrS, char *elemento, char clase){
  ptrNodoListaExpandible ptrNuevo;
  ptrNodoListaExpandible ptrAnterior;
  ptrNodoListaExpandible ptrActual;

  ptrNuevo = malloc(sizeof(NodoListaExpandible));

  if( ptrNuevo != NULL ){
    strncpy(ptrNuevo->elemento, elemento, strlen(elemento));
    ptrNuevo->clase = clase;
    ptrNuevo->ptrSig = NULL;

    ptrAnterior = NULL;
    ptrActual = *ptrS;

    if( clase == 1){  //Evita que los identificadores se repitan
      while( ptrActual != NULL ){
        if( comparaCadenas(ptrActual->elemento, elemento) == 1 ){
          return;
        }
        else{
          ptrAnterior = ptrActual;
          ptrActual = ptrActual->ptrSig;
        }
      }
    }

    else{ //En caso de no ser un identificador
      while( ptrActual != NULL ){
        ptrAnterior = ptrActual;
        ptrActual = ptrActual->ptrSig;
      }
    }

    if ( ptrAnterior == NULL ){
      ptrNuevo->ptrSig = *ptrS;
      *ptrS = ptrNuevo;
    }
    else{
      ptrAnterior->ptrSig = ptrNuevo;
      ptrNuevo->ptrSig = ptrActual;
    }
  }
  else{
    printf("No se inserto el valor\n");
  }
}

void imprimeLista( ptrNodoListaExpandible ptrActual ){
  char pos = 0;

  if ( ptrActual == NULL) {
    printf("La lista esta vacia\n");
  }
  else{
    while(ptrActual != NULL){
      if( ptrActual->clase == 1 || ptrActual->clase == 6){
          if( ptrActual->clase == 1 )
            printf("(%d, %s, )\n", pos++, (ptrActual->elemento) );
          else
            printf("(%d, %s)\n", pos++, (ptrActual->elemento) );
      }
      else
        printf("(%d, %s)\n", (ptrActual->clase), (ptrActual->elemento) );
      ptrActual = ptrActual->ptrSig;
    }
    printf("NULL\n");
  }
}

//Funciones de la lista ligada para la cadena de ATOMOS
void insertarAtomo( ptrNodoListaAtomos *ptrS, char atomo){
  ptrNodoListaAtomos ptrNuevo;
  ptrNodoListaAtomos ptrAnterior;
  ptrNodoListaAtomos ptrActual;

  ptrNuevo = malloc(sizeof(NodoListaAtomos));

  if( ptrNuevo != NULL ){
    ptrNuevo->atomo = atomo;
    ptrNuevo->ptrSig = NULL;

    ptrAnterior = NULL;
    ptrActual = *ptrS;

    while( ptrActual != NULL ){
      ptrAnterior = ptrActual;
      ptrActual = ptrActual->ptrSig;
    }

    if ( ptrAnterior == NULL ){
      ptrNuevo->ptrSig = *ptrS;
      *ptrS = ptrNuevo;
    }
    else{
      ptrAnterior->ptrSig = ptrNuevo;
      ptrNuevo->ptrSig = ptrActual;
    }
  }
  else{
    printf("No se inserto el valor\n");
  }
}

void imprimeListaAtomos( ptrNodoListaAtomos ptrActual ){
  char pos = 0;

  if ( ptrActual == NULL) {
    printf("La lista esta vacia\n");
  }
  else{
    while(ptrActual != NULL){
        printf("%c", (ptrActual->atomo) );
        ptrActual = ptrActual->ptrSig;
    }
    printf("NULL\n");
  }
}

//Convierte las listas a archivos dandole el formato solicitado
void lista2ArchivoToken(ptrNodoLista ptrInicial, FILE *fp){
  char *tmp;
  while(ptrInicial != NULL){
    if(ptrInicial->clase == 4 || ptrInicial->clase == 5){
      if(ptrInicial->clase == 4){
        tmp = regresaSimbolo(op.opArit, ptrInicial->posicion);
        fprintf(archSalida, "(%d, %c)\n", (ptrInicial->clase), tmp[0] );
      }
      else{
        tmp = regresaSimbolo(op.simbEsp, ptrInicial->posicion);
        fprintf(archSalida, "(%d, %c)\n", (ptrInicial->clase), tmp[0] );
      }
    }
    else
      fprintf(archSalida, "(%d, %d)\n", ptrInicial->clase, ptrInicial->posicion);
    ptrInicial = ptrInicial->ptrSig;
  }
  fprintf(archSalida, "\n");
}

void lista2ArchivoToken2(ptrNodoListaExpandible ptrActual, FILE *fp){
  char pos = 0;

  while(ptrActual != NULL){
    fprintf(archSalida, "(%d, %s)\n", ptrActual->clase, ptrActual->elemento);
    ptrActual = ptrActual->ptrSig;
  }
  fprintf(archSalida, "\n");
}

void lista2Archivo(ptrNodoListaExpandible ptrActual, char *titulo, FILE *fp){
  int pos = 0;

  fprintf(fp, "%s\n", titulo);
  while(ptrActual != NULL){
      fprintf(archSalida, "%d: %s\n", pos++, ptrActual->elemento);
    ptrActual = ptrActual->ptrSig;
  }
  fprintf(archSalida, "\n");
}

void lista2ArchivoAtomos(ptrNodoListaAtomos ptrInicial, char *titulo, FILE *fp){
  if (strlen(titulo) != 0 ) fprintf(fp, "%s\n", titulo);
  while(ptrInicial != NULL){
      fprintf(archSalida, "%c", ptrInicial->atomo);
      ptrInicial = ptrInicial->ptrSig;
  }
  fprintf(archSalida, "\n\n");
}

//FUNCIONES RECURSIVAS DEL ANALIZADOR SINTACTICO
void S(){
  insertar(&ptrInicialProd, "Produccion S", 100);
  //printf("char: %c\n", s);
  if( s == 's' || s == 'r' || s == 'c' || s == 'l' || s == 'e' ){
    D();
    DP();
    P();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "S: s r c l e", 99);
  }
  return;
}

void D(){
  insertar(&ptrInicialProd, "Produccion D", 100);
  //printf("char: %c\n", s);
  if( s == 's' || s == 'r' || s == 'c' || s == 'l' || s == 'e' ){
    TBP();
    if( s == 'a'){
        getNextChar();
        B();
        L();
    }
    else{
      insertar(&ptrInicialErrorSem, "D: a", 99);
      berror = 1;
    }
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "D: s r c l e", 99);
  }
  return;
}

void DP(){
  insertar(&ptrInicialProd, "Produccion DP", 100);
  //printf("char: %c\n", s);
  if( ( s == 's' || s == 'r' || s == 'c' || s == 'l' || s == 'e' ) ){
    D();
    DP();
  }
  else if( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a' ){
    return;
  } else {
    berror = 1;
    insertar(&ptrInicialErrorSem, "DP: s r c l e . m h i d a", 99);
  }
  return;
}

void TBP(){
  insertar(&ptrInicialProd, "Produccion TBP", 100);
  //printf("char: %c\n", s);
  if( s == 'c' || s == 'l' || s == 'e' ){
    N();
    if( s == 'e' ){
      getNextChar();
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "TBP: e", 99);
    }
  }
  else if( s == 's' || s == 'r' ){
    getNextChar();
  }
  else {
    berror = 1;
    insertar(&ptrInicialErrorSem, "TBP: s r c l e", 99);
  }
  return;
}

void N(){
  insertar(&ptrInicialProd, "Produccion N", 100);
  //printf("char: %c\n", s);
  if( ( s == 'c' || s == 'l') ){
    getNextChar();
  }
  else if( s == 'e'){
    return;
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "N: c l e", 99);
  }
  return;
}

void B(){
  insertar(&ptrInicialProd, "Produccion B", 100);
  //printf("char: %c\n", s);
  if( s == '=' ){
    getNextChar();
    J();
  }
  else if( s == '.' || s == ',' ){
    return;
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "B: . , =", 99);
  }
  return;
}

void J(){
  insertar(&ptrInicialProd, "Produccion J", 100);
  //printf("char: %c\n", s);
  if( s == 'x' || s == 'z' || s == 'y' ){
    getNextChar();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "J: x z y", 99);
  }
  return;
}

void L(){
  insertar(&ptrInicialProd, "Produccion L", 100);
  //printf("char: %c\n", s);
  if( s == ','){
    getNextChar();
    if( s == 'a'){
      getNextChar();
      B();
      L();
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "L: a", 99);
    }
  }
  else if( s == '.'){
    getNextChar();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "DP: . ,", 99);
  }
  return;
}

void P(){
  insertar(&ptrInicialProd, "Produccion P", 100);
  //printf("char: %c\n", s);
  if( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a' ){
    Z();
    PP();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "P: . m h i d a", 99);
  }
  return;
}

void Z(){
  insertar(&ptrInicialProd, "Produccion Z", 100);
  //printf("char: %c\n", s);
  if( s == '.' ){
    getNextChar();
  }
  else if( s == 'm' ){
    M();
  }
  else if( s == 'h' ){
    H();
  }
  else if( s == 'i' ){
    I();
  }
  else if( s == 'd' ){
    FP();
  }
  else if( s == 'a' ){
    A();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "Z: . m h i d a", 99);
  }
  return;
}

void PP(){
  insertar(&ptrInicialProd, "Produccion PP", 100);
  //printf("char: %c\n", s);
  if( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a' ){
    Z();
    PP();
  }
  else if( s == '?' || s == 'f' || s == 'b' || s == 't' || s == 'n' || s == 'g' ){
    return;
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "PP: . m h i d a f b t n g ?", 99);
  }
  return;
}

void M(){
  insertar(&ptrInicialProd, "Produccion M", 100);
  //printf("char: %c\n", s);
  if( s == 'm' ){
    getNextChar();
    if( s == '(' ){
      getNextChar();
      R();
      if( s == ')' ){
          getNextChar();
          P();
          if( s == 'f' ){
            getNextChar();
          }
          else{
            berror = 1;
            insertar(&ptrInicialErrorSem, "M: f", 99);
          }
      }
      else{
        berror = 1;
        insertar(&ptrInicialErrorSem, "M: )", 99);
      }
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "M: (", 99);
    }
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "M: m", 99);
  }
  return;
}

void H(){
  insertar(&ptrInicialProd, "Produccion H", 100);
  //printf("char: %c\n", s);
  if( s == 'h' ){
    getNextChar();
    P();
    if( s == 't' ){
      getNextChar();
      if( s == '(' ){
        getNextChar();
        R();
        if( s == ')' ){
          getNextChar();
          if( s == '.' ){
            getNextChar();
          }
          else{
            berror = 1;
            insertar(&ptrInicialErrorSem, "H: .", 99);
          }
        }
        else{
          berror = 1;
          insertar(&ptrInicialErrorSem, "H: )", 99);
        }
      }
      else{
        berror = 1;
        insertar(&ptrInicialErrorSem, "H: (", 99);
      }
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "H: t", 99);
    }
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "H: h", 99);
  }
  return;
}

void I(){
  insertar(&ptrInicialProd, "Produccion I", 100);
  //printf("char: %c\n", s);
  if( s == 'i' ){
    getNextChar();
    if( s == '(' ){
      getNextChar();
      R();
      if( s == ')' ){
        getNextChar();
        P();
        G();
      }
      else{
        berror = 1;
        insertar(&ptrInicialErrorSem, "I: )", 99);
      }
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "I: (", 99);
    }
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "I: i", 99);
  }
  return;
}

void G(){
  insertar(&ptrInicialProd, "Produccion G", 100);
  //printf("char: %c\n", s);
  if( s == 'n' ){
    getNextChar();
    P();
    if( s == 'b' ){
      getNextChar();
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "G: b", 99);
    }
  }
  else if( s == 'b' ){
    getNextChar();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "G: n b", 99);
  }
  return;
}

void FP(){
  insertar(&ptrInicialProd, "Produccion FP", 100);
  //printf("char: %c\n", s);
  if( s == 'd' ){
    getNextChar();
    A();
    if( s == 't' ){
      getNextChar();
      if( s == '(' ){
        getNextChar();
        E();
        if( s == ')' ){
          getNextChar();
          if( s == 'p' ){
            getNextChar();
            if( s == '(' ){
              getNextChar();
              E();
              if( s == ')' ){
                getNextChar();
                P();
                if( s == 'g' ){
                  getNextChar();
                }
                else{
                  berror = 1;
                  insertar(&ptrInicialErrorSem, "FP: g", 99);
                }
              }
              else{
                berror = 1;
                insertar(&ptrInicialErrorSem, "FP: )", 99);
              }
            }
            else{
              berror = 1;
              insertar(&ptrInicialErrorSem, "FP: (", 99);
            }
          }
          else{
            berror = 1;
            insertar(&ptrInicialErrorSem, "FP: p", 99);
          }
        }
        else{
          berror = 1;
          insertar(&ptrInicialErrorSem, "FP: )", 99);
        }
      }
      else{
        berror = 1;
        insertar(&ptrInicialErrorSem, "FP: (", 99);
      }
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "FP: t", 99);
    }
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "FP: d", 99);
  }
  return;
}

void A(){
  insertar(&ptrInicialProd, "Produccion A", 100);
  //printf("char: %c\n", s);
  if( s == 'a' ){
    getNextChar();
    if( s == '=' ){
      getNextChar();
      E();
      if( s == '.' ){
        getNextChar();
      }
      else{
        berror = 1;
        insertar(&ptrInicialErrorSem, "A: .", 99);
      }
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "A: =", 99);
    }
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "A: a", 99);
  }
  return;
}

void R(){
  insertar(&ptrInicialProd, "Produccion R", 100);
  //printf("char: %c\n", s);
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' || s == 'y' ){
    E();
    O();
    E();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "R: ( a x z y", 99);
  }
  return;
}

void O(){
  insertar(&ptrInicialProd, "Produccion O", 100);
  //printf("char: %c\n", s);
  if( s == 'j' || s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){
    getNextChar();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "O: j k q u v w", 99);
  }
  return;
}

void E(){
  insertar(&ptrInicialProd, "Produccion E", 100);
  //printf("char: %c\n", s);
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' || s == 'y' ){
    T();
    EP();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "E: ( a x z y", 99);
  }
  return;
}

void EP(){
  insertar(&ptrInicialProd, "Produccion EP", 100);
  //printf("char: %c\n", s);
  if( ( s == '+' || s == '-' ) ){
    getNextChar();
    T();
    EP();
  }
  else if( s == ')' || s == '.' || s == 'j' ||  s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){
    return;
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "EP: + - ) . j k q u v w", 99);
  }
  return;
}

void T(){
  insertar(&ptrInicialProd, "Produccion T", 100);
  //printf("char: %c\n", s);
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' || s == 'y'){
    F();
    TP();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "T: ( a x z y", 99);
  }
  return;
}

void TP(){
  insertar(&ptrInicialProd, "Produccion TP", 100);
  //printf("char: %c\n", s);
  if( ( s == '*' || s == '/' ) ){
    getNextChar();
    F();
    TP();
  }
  else if( s == '+' || s == '-' || s == ')' || s == '.' || s == 'j' ||  s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){
    return;
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "TP: * / + - ) . j k q u v w", 99);
  }
  return;
}

void F(){
  insertar(&ptrInicialProd, "Produccion F", 100);
  //printf("char: %c\n", s);
  if( s == '(' ){
    getNextChar();
    E();
    if( s == ')' ){
      getNextChar();
    }
    else{
      berror = 1;
      insertar(&ptrInicialErrorSem, "F: )", 99);
    }
  }
  else if( s == 'a' ){
    getNextChar();
  }
  else if( s == 'x' || s == 'z' || s == 'y' ){
    J();
  }
  else{
    berror = 1;
    insertar(&ptrInicialErrorSem, "F: ( a x z", 99);
  }
  return;
}

void Parser(){
  //insertar(&ptrInicialProd, "Produccion Parser", 100);
  if(ptrInicialAtomos == NULL){
    printf("Error en el apuntador");
  }
  else{
    getNextChar();
    S();
    if( berror != 1 ){
      error("PROGRAMA CORRECTO :D\n ", archSalida);
    }
    else{
      error("PROGRAMA CON ERRORES :(\n", archSalida);
    }
  }
  return;
}

void getNextChar(){
  if( ptrInicialAtomos2->atomo == '?' ){
    s = '?';
  }
  else{
    s = ptrInicialAtomos2->atomo;
    ptrInicialAtomos2 = ptrInicialAtomos2->ptrSig;
  }
}

char comparaCadenas(char *s1, char *s2){
  char size1 = strlen(s1);
  char size2 = strlen(s2);
  char iguales = 0;

  if ( size1 == size2 ){
    if (strncmp(s1, s2, size1) == 0){
      iguales = 1;
    }
  }
  return iguales;
}

void error(char *s, FILE *fp){
  fprintf(fp, "%s\n", s);
}
