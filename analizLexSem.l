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
  #define LONG_MAX_SYM 12
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
  void lista2Archivo(ptrNodoListaExpandible ptrInicial, char *titulo, FILE *fp);

  char decodificadorAtomos(char *string);

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
  ptrNodoListaAtomos ptrInicialAtomos = NULL;

  //Funciones del analizador SINTACTICO
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
consEnt    {signo}?[0-9]+
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

  imprimeListaAtomos(ptrInicialAtomos);
  lista2ArchivoToken(ptrInicialTokens, archSalida);
  lista2Archivo(ptrInicialIden, "\nIdentificadores", archSalida);
  lista2Archivo(ptrInicialCad, "Cadenas", archSalida);
  lista2Archivo(ptrInicialConstEnt, "Constantes enteras", archSalida);
  lista2Archivo(ptrInicialConstReal, "Constantes reales", archSalida);
  lista2Archivo(ptrInicialError, "Errores", archSalida);
  Parser(ptrInicialAtomos);
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
  fprintf(fp, "Tokens de tablas estaticas:\n");
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
}

void lista2Archivo(ptrNodoListaExpandible ptrActual, char *titulo, FILE *fp){
  char pos = 0;

  fprintf(fp, "%s\n", titulo);
  while(ptrActual != NULL){
    if( ptrActual->clase == 1 || ptrActual->clase == 6 || ptrActual->clase == 9){
        if( ptrActual->clase == 1 )
          fprintf(fp, "(%d, %s, )\n", pos++, (ptrActual->elemento) );
        else
          fprintf(fp, "(%d, %s)\n", pos++, (ptrActual->elemento) );
    }
    else
      fprintf(archSalida, "(%d, %s)\n", ptrActual->clase, ptrActual->elemento);
    ptrActual = ptrActual->ptrSig;
  }
  fprintf(archSalida, "\n");
}


//FUNCIONES RECURSIVAS DEL ANALIZADOR SINTACTICO
void S(){
  printf("Produccion S\n");
  //printf("char: %c\n", s);
  if( s == 's' || s == 'r' || s == 'c' || s == 'l' || s == 'e' ){
    D();
    DP();
    P();
  }
  else{
    berror = 1;
    printf("Error en S");
  }
  return;
}

void D(){
  printf("Produccion D\n");
  //printf("char: %c\n", s);
  if( s == 's' || s == 'r' || s == 'c' || s == 'l' || s == 'e' ){
    TBP();
    if( s == 'a'){
        s = ptrInicialAtomos->atomo;
        ptrInicialAtomos = ptrInicialAtomos->ptrSig;
        B();
        L();
    }
    else{
      printf("Un tipo de dato debe ser seguido por un identificador\n");
      berror = 1;
    }
  }
  else{
    berror = 1;
    printf("Error D");
  }
  return;
}

void DP(){
  printf("Produccion DP\n");
  //printf("char: %c\n", s);
  if( ptrInicialAtomos != NULL && ( s == 's' || s == 'r' || s == 'c' || s == 'l' || s == 'e' ) ){
    D();
    DP();
  }
  else if( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a' ){

  } else {
    berror = 1;
    printf("Error DP");
  }
  return;
}

void TBP(){
  printf("Produccion TBP\n");
  //printf("char: %c\n", s);
  if( s == 'c' || s == 'l' || s == 'e' ){
    N();
    if( s == 'e' ){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    }
    else{
      berror = 1;
      printf("Error TBP");
    }
  }
  else if( s == 's' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  else if( s == 'r' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  else {
    berror = 1;
    printf("Error TBP");
  }
  return;
}

void N(){
  printf("Produccion N\n");
  //printf("char: %c\n", s);
  if( ptrInicialAtomos != NULL && ( s == 'c' || s == 'l') ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  else if( s == 'e'){

  }
  else{
    berror = 1;
    printf("Error en N");
  }
  return;
}

void B(){
  printf("Produccion B\n");
  //printf("char: %c\n", s);
  if( ptrInicialAtomos != NULL && s == '=' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    J();
  }
  else if( s == '.' || s == ',' ){

  }
  else{
    berror = 1;
    printf("Error B");
  }
  return;
}

void J(){
  printf("Produccion J\n");
  //printf("char: %c\n", s);
  if( s == 'x' || s == 'z'){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  else{
    berror = 1;
    printf("Error J");
  }
  return;
}

void L(){
  printf("Produccion L\n");
  //printf("char: %c\n", s);
  if( ptrInicialAtomos != NULL && s == ','){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    if( s == 'a'){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
      B();
      L();
    }
    else{
      berror = 1;
      printf("Error L");
    }
  }
  else if( ptrInicialAtomos != NULL && s == '.'){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  else{
    berror = 1;
    printf("Error L");
  }
  return;
}

void P(){
  printf("Produccion P\n");
  //printf("char: %c\n", s);
  if( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a' ){
    Z();
    PP();
  }
  else{
    berror = 1;
    printf("Error P");
  }
}

void Z(){
  printf("Produccion Z\n");
  //printf("char: %c\n", s);
  if( ptrInicialAtomos != NULL && s == '.' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  if(ptrInicialAtomos == NULL){

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
    printf("Error Z");
  }
  return;
}

void PP(){
  printf("Produccion PP\n");
  //printf("char: %c\n", s);
  if( ptrInicialAtomos != NULL && ( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a') ){
    Z();
    PP();
  }
  else if( ptrInicialAtomos == NULL || s == 'f' || s == 'b' || s == 't' || s == 'n' || s == 'g' ){

  }
  else{
    berror = 1;
    printf("Error PP");
  }
  return;
}

void M(){
  printf("Produccion M\n");
  //printf("char: %c\n", s);
  if( s == 'm' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    if( s == '(' ){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
      R();
      if( s == ')' ){
          s = ptrInicialAtomos->atomo;
          ptrInicialAtomos = ptrInicialAtomos->ptrSig;
          P();
          if( s == 'f' ){
            s = ptrInicialAtomos->atomo;
            ptrInicialAtomos = ptrInicialAtomos->ptrSig;
          }
          else{
            berror = 1;
            printf("Error M");
          }
      }
      else{
        berror = 1;
        printf("Error M");
      }
    }
    else{
      berror = 1;
      printf("Error M");
    }
  }
  else{
    berror = 1;
    printf("Error M");
  }
  return;
}

void H(){
  printf("Produccion H\n");
  //printf("char: %c\n", s);
  if( s == 'h' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    P();
    if( s == 't' ){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
      if( s == '(' ){
        s = ptrInicialAtomos->atomo;
        ptrInicialAtomos = ptrInicialAtomos->ptrSig;
        R();
        if( s == ')' ){
          s = ptrInicialAtomos->atomo;
          ptrInicialAtomos = ptrInicialAtomos->ptrSig;
          if( s == '.' ){
            s = ptrInicialAtomos->atomo;
            ptrInicialAtomos = ptrInicialAtomos->ptrSig;
          }
          else{
            berror = 1;
            printf("Error H");
          }
        }
        else{
          berror = 1;
          printf("Error H");
        }
      }
      else{
        berror = 1;
        printf("Error H");
      }
    }
    else{
      berror = 1;
      printf("Error H");
    }
  }
  else{
    berror = 1;
    printf("Error H");
  }
  return;
}

void I(){
  printf("Produccion I\n");
  //printf("char: %c\n", s);
  if( s == 'i' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    if( s == '(' ){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
      R();
      if( s == ')' ){
        s = ptrInicialAtomos->atomo;
        ptrInicialAtomos = ptrInicialAtomos->ptrSig;
        P();
        G();
      }
      else{
        berror = 1;
        printf("Error I");
      }
    }
    else{
      berror = 1;
      printf("Error I");
    }
  }
  else{
    berror = 1;
    printf("Error I");
  }
  return;
}

void G(){
  printf("Produccion G\n");
  //printf("char: %c\n", s);
  if( s == 'n' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    P();
    if( s == 'b' ){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    }
    else{
      berror = 1;
      printf("Error G");
    }
  }
  else if( s == 'b' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  else{
    berror = 1;
    printf("Error G");
  }
  return;
}

void FP(){
  printf("Produccion FP\n");
  //printf("char: %c\n", s);
  if( s == 'd' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    A();
    if( s == 't' ){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
      if( s == '(' ){
        s = ptrInicialAtomos->atomo;
        ptrInicialAtomos = ptrInicialAtomos->ptrSig;
        E();
        if( s == ')' ){
          s = ptrInicialAtomos->atomo;
          ptrInicialAtomos = ptrInicialAtomos->ptrSig;
          if( s == 'p' ){
            s = ptrInicialAtomos->atomo;
            ptrInicialAtomos = ptrInicialAtomos->ptrSig;
            if( s == '(' ){
              s = ptrInicialAtomos->atomo;
              ptrInicialAtomos = ptrInicialAtomos->ptrSig;
              E();
              if( s == ')' ){
                s = ptrInicialAtomos->atomo;
                ptrInicialAtomos = ptrInicialAtomos->ptrSig;
                P();
                if( s == 'g' ){
                  s = ptrInicialAtomos->atomo;
                  ptrInicialAtomos = ptrInicialAtomos->ptrSig;
                }
                else{
                  berror = 1;
                  printf("Error FP");
                }
              }
              else{
                berror = 1;
                printf("Error FP");
              }
            }
            else{
              berror = 1;
              printf("Error FP");
            }
          }
          else{
            berror = 1;
            printf("Error FP");
          }
        }
        else{
          berror = 1;
          printf("Error FP");
        }
      }
      else{
        berror = 1;
        printf("Error FP");
      }
    }
    else{
      berror = 1;
      printf("Error FP");
    }
  }
  else{
    berror = 1;
    printf("Error FP");
  }
  return;
}

void A(){
  printf("Produccion A\n");
  //printf("char: %c\n", s);
  if( s == 'a' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    if( s == '=' ){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
      E();
      if( s == '.' ){
        s = ptrInicialAtomos->atomo;
        ptrInicialAtomos = ptrInicialAtomos->ptrSig;
      }
      else{
        berror = 1;
        printf("Error A");
      }
    }
    else{
      berror = 1;
      printf("Error A");
    }
  }
  else{
    berror = 1;
    printf("Error A");
  }
  return;
}

void R(){
  printf("Produccion R\n");
  //printf("char: %c\n", s);
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' ){
    E();
    O();
    E();
  }
  else{
    berror = 1;
    printf("Error R");
  }
  return;
}

void O(){
  printf("Produccion O\n");
  //printf("char: %c\n", s);
  if( s == 'j' || s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  else{
    berror = 1;
    printf("Error O");
  }
  return;
}

void E(){
  printf("Produccion E\n");
  //printf("char: %c\n", s);
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' ){
    T();
    EP();
  }
  else{
    berror = 1;
    printf("Error E");
  }
  return;
}

void EP(){
  printf("Produccion EP\n");
  //printf("char: %c\n", s);
  if( ptrInicialAtomos != NULL && ( s == '+' || s == '-' ) ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    T();
    EP();
  }
  else if( s == '(' || s == ')' || s == '.' || s == 'j' ||  s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){

  }
  else{
    berror = 1;
    printf("Error EP");
  }
  return;
}

void T(){
  printf("Produccion T\n");
  //printf("char: %c\n", s);
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' ){
    F();
    TP();
  }
  else{
    berror = 1;
    printf("Error T");
  }
  return;
}

void TP(){
  printf("Produccion TP\n");
  //printf("char: %c\n", s);
  if( ptrInicialAtomos != NULL && ( s == '*' || s == '/' ) ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    F();
    TP();
  }
  else if( s == '+' || s == '-' || s == '(' || s == ')' || s == '.' || s == 'j' ||  s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){

  }
  else{
    berror = 1;
    printf("Error TP");
  }
  return;
}

void F(){
  printf("Produccion F\n");
  //printf("char: %c\n", s);
  if( s == '(' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    E();
    if( s == ')' ){
      s = ptrInicialAtomos->atomo;
      ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    }
    else{
      berror = 1;
      printf("Error F");
    }
  }
  else if( s == 'a' ){
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
  }
  else if( s == 'x' || s == 'z' ){
    J();
  }
  else{
    berror = 1;
    printf("Error F");
  }
  return;
}

void Parser(){
  printf("Produccion Parser\n");
  if(ptrInicialAtomos == NULL){
    printf("Error en el apuntador");
  }
  else{
    s = ptrInicialAtomos->atomo;
    ptrInicialAtomos = ptrInicialAtomos->ptrSig;
    S();
    if( berror != 1 ){
      printf("PROGRAMA CORRECTO");
    }
    else{
      printf("Errores sintacticos");
    }
  }
}
