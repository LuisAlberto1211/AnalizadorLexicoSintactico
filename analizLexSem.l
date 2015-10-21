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

  //Estructuras donde se almacenaran las cadenas una vez identificadas
  ptrNodoLista ptrInicialTokens = NULL;
  ptrNodoListaExpandible ptrInicialIden = NULL;
  ptrNodoListaExpandible ptrInicialCad = NULL;
  ptrNodoListaExpandible ptrInicialConstEnt = NULL;
  ptrNodoListaExpandible ptrInicialConstReal = NULL;
  ptrNodoListaExpandible ptrInicialError = NULL;
  ptrNodoListaAtomos ptrInicialAtomos = NULL;

  //Funciones del analizador SINTACTICO
  void S(ptrNodoListaAtomos cadena);
  void D(ptrNodoListaAtomos cadena);
  void DP(ptrNodoListaAtomos cadena);
  void TBP(ptrNodoListaAtomos cadena);
  void N(ptrNodoListaAtomos cadena);
  void B(ptrNodoListaAtomos cadena);
  void J(ptrNodoListaAtomos cadena);
  void L(ptrNodoListaAtomos cadena);
  void P(ptrNodoListaAtomos cadena);
  void Z(ptrNodoListaAtomos cadena);
  void PP(ptrNodoListaAtomos cadena);
  void M(ptrNodoListaAtomos cadena);
  void H(ptrNodoListaAtomos cadena);
  void I(ptrNodoListaAtomos cadena);
  void G(ptrNodoListaAtomos cadena);
  void FP(ptrNodoListaAtomos cadena);
  void A(ptrNodoListaAtomos cadena);
  void R(ptrNodoListaAtomos cadena);
  void O(ptrNodoListaAtomos cadena);
  void E(ptrNodoListaAtomos cadena);
  void EP(ptrNodoListaAtomos cadena);
  void T(ptrNodoListaAtomos cadena);
  void TP(ptrNodoListaAtomos cadena);
  void F(ptrNodoListaAtomos cadena);
  void Parser(ptrNodoListaAtomos cadena);
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
void S(ptrNodoListaAtomos cadena){
  if( s == 's' || s == 'r' || s == 'c' || s == 'l' ){
    T(cadena->ptrSig);
    DP(cadena->ptrSig);
    P(cadena->ptrSig);
  }
  else{
    printf("Error");
  }
  return;
}

void D(ptrNodoListaAtomos cadena){
  if( s == 's' || s == 'r' || s == 'c' || s == 'l' ){
    T(cadena->ptrSig);
    if(s == 'a'){
        s = cadena->atomo;
        B(cadena->ptrSig);
        L(cadena->ptrSig);
    }
    else{
      printf("Error");
    }
  }
  else{
    printf("Error");
  }
  return;
}

void DP(ptrNodoListaAtomos cadena){
  if( s == 's' || s == 'r' || s == 'c' || s == 'l' ){
    D(cadena->ptrSig);
    DP(cadena->ptrSig);
  }
  else if( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a' ){

  } else {
    printf("Error");
  }
  return;
}

void TBP(ptrNodoListaAtomos cadena){
  if( s == 'c' || s == 'l' ){
    N(cadena->ptrSig);
    if( s == 'e'){
      s = cadena->atomo;
    }
    else{
      printf("Error");
    }
  }
  else if( s == 's' ){
    s = cadena->atomo;
  }
  else if( s == 'r' ){
    s = cadena->atomo;
  }
  else {
    printf("Error");
  }
  return;
}

void N(ptrNodoListaAtomos cadena){
  if( s == 'c' || s == 'l' ){
    s = cadena->atomo;
  }
  else if( s == 'e'){

  }
  else{
    printf("Error");
  }
  return;
}

void B(ptrNodoListaAtomos cadena){
  if( s == '=' ){
    s = cadena->atomo;
    J(cadena->ptrSig);
  }
  else if( s == 'l' ){

  }
  else{
    printf("Error");
  }
  return;
}

void J(ptrNodoListaAtomos cadena){
  if( s == 'x' || s == 'z'){
    s = cadena->atomo;
  }
  else{
    printf("Error");
  }
  return;
}

void L(ptrNodoListaAtomos cadena){
  if( s == ','){
    s = cadena->atomo;
    if( s == 'a'){
      s = cadena->atomo;
      B(cadena->ptrSig);
      L(cadena->ptrSig);
    }
    else{
      printf("Error");
    }
  }
  else if( s == '.'){
    s = cadena->atomo;
  }
  else{
    printf("Error");
  }
  return;
}

void P(ptrNodoListaAtomos cadena){
  if( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a' ){
    Z(cadena->ptrSig);
    PP(cadena->ptrSig);
  }
  else{
    printf("Error");
  }
}

void Z(ptrNodoListaAtomos cadena){
  if( s == '.' ){
    s = cadena->atomo;
  }
  else if( s == 'm' ){
    M(cadena->ptrSig);
  }
  else if( s == 'h' ){
    H(cadena->ptrSig);
  }
  else if( s == 'i' ){
    I(cadena->ptrSig);
  }
  else if( s == 'd' ){
    FP(cadena->ptrSig);
  }
  else if( s == 'a' ){
    A(cadena->ptrSig);
  }
  else{
    printf("Error");
  }
  return;
}

void PP(ptrNodoListaAtomos cadena){
  if( s == '.' || s == 'm' || s == 'h' || s == 'i' || s == 'd' || s == 'a' ){
    Z(cadena->ptrSig);
    PP(cadena->ptrSig);
  }
  else if( s == 'f' || s == 'b' || s == 'm' || s == 'n' || s == 'g' || cadena == NULL ){

  }
  else{
    printf("Error");
  }
  return;
}

void M(ptrNodoListaAtomos cadena){
  if( s == 'm' ){
    s = cadena->atomo;
    if( s == '(' ){
      s = cadena->atomo;
      R(cadena->ptrSig);
      if( s == ')' ){
          s = cadena->atomo;
          P(cadena->ptrSig);
          if( s == 'f' ){
            s = cadena->atomo;
          }
          else{
            printf("Error");
          }
      }
      else{
        printf("Error");
      }
    }
    else{
      printf("Error");
    }
  }
  else{
    printf("Error");
  }
  return;
}

void H(ptrNodoListaAtomos cadena){
  if( s == 'h' ){
    s = cadena->atomo;
    P(cadena->ptrSig);
    if( s == 'm' ){
      s = cadena->atomo;
      if( s == '(' ){
        s = cadena->atomo;
        R(cadena->ptrSig);
        if( s == ')' ){
          s = cadena->atomo;
          if( s == '.' ){
            s = cadena->atomo;
          }
          else{
            printf("Error");
          }
        }
        else{
          printf("Error");
        }
      }
      else{
        printf("Error");
      }
    }
    else{
      printf("Error");
    }
  }
  else{
    printf("Error");
  }
  return;
}

void I(ptrNodoListaAtomos cadena){
  if( s == 'i' ){
    s = cadena->atomo;
    if( s == '(' ){
      s = cadena->atomo;
      R(cadena->ptrSig);
      if( s == ')' ){
        s = cadena->atomo;
        P(cadena->ptrSig);
        G(cadena->ptrSig);
      }
      else{
        printf("Error");
      }
    }
    else{
      printf("Error");
    }
  }
  else{
    printf("Error");
  }
  return;
}

void G(ptrNodoListaAtomos cadena){
  if( s == 'n' ){
    s = cadena->atomo;
    P(cadena->ptrSig);
    if( s == 'b' ){
      s = cadena->atomo;
    }
    else{
      printf("Error");
    }
  }
  else if( s == 'b' ){
    s = cadena->atomo;
  }
  else{
    printf("Error");
  }
  return;
}

void FP(ptrNodoListaAtomos cadena){
  if( s == 'd' ){
    s = cadena->atomo;
    A(cadena->ptrSig);
    if( s == 't' ){
      s = cadena->atomo;
      if( s == '(' ){
        s = cadena->atomo;
        E(cadena->ptrSig);
        if( s == ')' ){
          s = cadena->atomo;
          if( s == 'p' ){
            s = cadena->atomo;
            if( s == '(' ){
              s = cadena->atomo;
              E(cadena->ptrSig);
              if( s == ')' ){
                s = cadena->atomo;
                P(cadena->ptrSig);
                if( s == 'g' ){
                  s = cadena->atomo;
                }
                else{
                  printf("Error");
                }
              }
              else{
                printf("Error");
              }
            }
            else{
              printf("Error");
            }
          }
          else{
            printf("Error");
          }
        }
        else{
          printf("Error");
        }
      }
      else{
        printf("Error");
      }
    }
    else{
      printf("Error");
    }
  }
  else{
    printf("Error");
  }
  return;
}

void A(ptrNodoListaAtomos cadena){
  if( s == 'a' ){
    s = cadena->atomo;
    if( s == '=' ){
      s = cadena->atomo;
      E(cadena->ptrSig);
      if( s == '.' ){
        s = cadena->atomo;
      }
      else{
        printf("Error");
      }
    }
    else{
      printf("Error");
    }
  }
  else{
    printf("Error");
  }
  return;
}

void R(ptrNodoListaAtomos cadena){
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' ){
    E(cadena->ptrSig);
    O(cadena->ptrSig);
    E(cadena->ptrSig);
  }
  else{
    printf("Error");
  }
  return;
}

void O(ptrNodoListaAtomos cadena){
  if( s == 'j' || s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){
    s = cadena->atomo;
  }
  else{
    printf("Error");
  }
  return;
}

void E(ptrNodoListaAtomos cadena){
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' ){
    T(cadena->ptrSig);
    EP(cadena->ptrSig);
  }
  else{
    printf("Error");
  }
  return;
}

void EP(ptrNodoListaAtomos cadena){
  if( s == '+' || s == '-' ){
    s = cadena->atomo;
    T(cadena->ptrSig);
    EP(cadena->ptrSig);
  }
  else if( s == '(' || s == ')' || s == '.' || s == 'j' ||  s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){

  }
  else{
    printf("Error");
  }
  return;
}

void T(ptrNodoListaAtomos cadena){
  if( s == '(' || s == 'a' || s == 'x' || s == 'z' ){
    F(cadena->ptrSig);
    TP(cadena->ptrSig);
  }
  else{
    printf("Error");
  }
  return;
}

void TP(ptrNodoListaAtomos cadena){
  if( s == '*' || s == '/' ){
    s = cadena->atomo;
    F(cadena->ptrSig);
    TP(cadena->ptrSig);
  }
  else if( s == '+' || s == '-' || s == '(' || s == ')' || s == '.' || s == 'j' ||  s == 'k' || s == 'q' || s == 'u' || s == 'v' || s == 'w' ){

  }
  else{
    printf("Error");
  }
  return;
}

void F(ptrNodoListaAtomos cadena){
  if( s == '(' ){
    s = cadena->atomo;
    E(cadena->ptrSig);
    if( s == ')' ){
      s = cadena->atomo;
    }
    else{
      printf("Error");
    }
  }
  else if( s == 'a' ){
    s = cadena->atomo;
  }
  else if( s == 'x' || s == 'z' ){
    J(cadena->ptrSig);
  }
  else{
    printf("Error");
  }
  return;
}

void Parser(ptrNodoListaAtomos cadena){
  s = cadena->atomo;
  S(cadena->ptrSig);
  if( s == '.' ){
    printf("PROGRAMA CORRECTO");
  }
  else{
    printf("Errores sintacticos");
  }
}
