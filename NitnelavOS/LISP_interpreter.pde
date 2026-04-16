/**
 * Programme crée par Nitnelav00 en 2026.
 *
 * L'interpréteur LISP a été inspiré par https://norvig.com/lispy.html
 * pour avoir une possibilité de faire des scripts dans l'OS
 */

/*
 * La classe Env représente l'environnement d'éxécution de l'interpréteur LISP
 * Tous les symboles des fonctions et constantes sont enregistrés ici
 */
class Env extends HashMap<String, Object> {
  Env autre; // lien avec les différents environnements

  Env(ArrayList<String> params, ArrayList<Object> args, Env autre_) {
    super();
    this.autre = autre_;
    for (int i = 0; i < params.size(); i++) {
      put(params.get(i), args.get(i));
    }
  }

  // constructeur par défaut
  Env() {
    super();
    this.autre = null;
  }

  /*
   * Méthode pour trouver le symbole correspondant
   */
  Env find(String v) {
    if (this.containsKey(v)) { // S'il contien le symbole alors pas besoin de chercher plus loin
      return this;
    } else if (autre != null) {
      return autre.find(v);
    } else {
      throw new RuntimeException("Symbole indéfini: " + v);
    }
  }
}

interface Fonc { // Pour créer des fonctions facilement
  Object apply(ArrayList<Object> args, Env env);
}

/*
 * Les fonctions
 */
class Fonction implements Fonc {
  ArrayList<String> params;
  Object body;
  Env env;

  Fonction(ArrayList<String> params, Object body, Env env) {
    this.params = params;
    this.body = body;
    this.env = env;
  }

  Object apply(ArrayList<Object> args, Env env_) {
    Env local = new Env(params, args, env); // L'environnement utilisé est celui de la fonctions
    return lispEval(body, local);
  }
}

/*
 * Le texte soit être transformé en tokens avant d'être éxécuté
 */
ArrayList<String> tokenize(String chars) {
  ArrayList<String> tokens = new ArrayList<String>();
  StringBuilder enTokenisation = new StringBuilder(); // utilise un StringBuilder pour que ce soit plus simple de gérer du texte
  boolean dansString = false; // Savoir si le texte est entre guillements double

  for (int i = 0; i < chars.length(); i++) {
    char c = chars.charAt(i);

    // bascule dans/ hors du mode chaîne
    if (c == '"' && !dansString) { // dans
      dansString = true;
      enTokenisation.append(c);
    } else if (c == '"' && dansString) { // hors
      dansString = false;
      enTokenisation.append(c);
      if (enTokenisation.length() > 0) { // si le String n'est pas vide, l'ajouter aux tokens
        tokens.add(enTokenisation.toString().replace("\\n", "\n"));
        enTokenisation = new StringBuilder();
      }
    }

    // si on est dans une chaîne, on ajoute tout tel quel
    else if (dansString) {
      enTokenisation.append(c);
    }

    // sinon on traite espaces, parenthèses et autres
    else {
      if (c == '(' || c == ')') { // parenthèses
        if (enTokenisation.length() > 0) {
          tokens.add(enTokenisation.toString());
          enTokenisation = new StringBuilder();
        }
        tokens.add(String.valueOf(c));
      } else if (Character.isWhitespace(c)) { // espaces
        if (enTokenisation.length() > 0) {
          tokens.add(enTokenisation.toString());
          enTokenisation = new StringBuilder();
        }
      } else {
        enTokenisation.append(c); // autres
      }
    }
  }

  // token restant à la fin
  if (enTokenisation.length() > 0) {
    tokens.add(enTokenisation.toString());
  }

  return tokens;
}

/*
 * Les tokens doivent ensuite être transformés en instructions
 * On utilise le parser pour ça
 */
class Parser {
  ArrayList<String> tokens;
  int pos = 0;

  Parser(ArrayList<String> tokens) {
    this.tokens = tokens;
  }

  Object lireDepuisTokens() {
    if (pos >= tokens.size()) { // La position ne doit pas être plus grande que le nombre de tokens
      throw new RuntimeException("Fin de ligne innatendu");
    }

    String token = tokens.get(pos++); // obtenir le suivant
    if (token.equals("(")) { // Si on est dans un parenthèse
      ArrayList<Object> L = new ArrayList<Object>();
      while (!tokens.get(pos).equals(")")) { // éxecuter tout ce qu'il y a à l'intérieur
        L.add(lireDepuisTokens());
      }
      pos++; // skip ")"
      return L;
    } else if (token.equals(")")) { // Si une parenthèse de trop est fermée, renvoyer une erreur
      throw new RuntimeException(") innatendu");
    } else {
      return atom(token); // sinon parser le symbole
    }
  }

  Object atom(String token) {
    try {
      return Integer.parseInt(token); // entier
    }
    catch (NumberFormatException e1) {
      try {
        return Float.parseFloat(token); // flottant
      }
      catch (NumberFormatException e2) {
        return token; // Symbole
      }
    }
  }
}
Object parse(String program) { // parser tout les tokens
  ArrayList<String> toks = tokenize(program);
  return new Parser(toks).lireDepuisTokens();
}

/**
 * Évalue une expression Lisp dans un environnement donné.
 * À utiliser dans la commande 'lisp' du Terminal.
 */
Object lispEval(Object x, Env env) {
  // 1) atomes (chaînes, symboles, nombres)
  if (x instanceof String) { // Si x est une chaine de charactères
    String s = (String)x;
    if (s.length() >= 2 && s.startsWith("\"") && s.endsWith("\"")) { // enlever les guillemets et le retourner
      return s;
    }
    return env.find(s).get(s);
  }

  if (!(x instanceof ArrayList)) { // Si y n'est pas une liste, le renvoyer
    return x;
  }

  ArrayList<Object> lst = (ArrayList<Object>)x;
  if (lst.isEmpty()) { // si la liste est vide, il n'y a rien à faire
    return null;
  }

  Object operateur = lst.get(0); // Le premier item de la liste est l'opérateur (define, if ou lambda)
  if (operateur instanceof String) {
    String opStr = (String)operateur;

    // ---------
    // define
    // ---------
    if (opStr.equals("define")) {
      if (lst.size() < 3) {
        throw new RuntimeException("define: besoin de (define symbol expr)");
      }
      Object symbole = lst.get(1);
      if (!(symbole instanceof String)) {
        throw new RuntimeException("define: premier argument doit être un symbole");
      }
      String varName = (String)symbole;
      Object value = lispEval(lst.get(2), env); // évaluer l'intérieur
      env.put(varName, value);
      return null; // define ne renvoie rien
    }

    // ------
    // if
    // ------
    if (opStr.equals("if")) {
      if (lst.size() < 3 || lst.size() > 4) {
        throw new RuntimeException("if: besoin de (if test then [else])");
      }
      Object test = lispEval(lst.get(1), env); // évaluer l'intérieur

      boolean testOk = false;
      if (test instanceof Boolean)
        testOk = (boolean)test;
      else if (test instanceof Number)
        testOk = ((Number) test).floatValue() != 0.0; // si un nombre est utilisé
      else
        testOk = test != null;

      Object branch = testOk ? lst.get(2) : (lst.size() == 4 ? lst.get(3) : null); // Si la branche "else" existe et est utilisée
      if (branch != null) {
        return lispEval(branch, env);
      } else {
        return null;
      }
    }

    // ------
    // lambda -> Foncedure
    // ------
    if (opStr.equals("lambda")) {
      if (lst.size() < 3) {
        throw new RuntimeException("lambda: besoin de (lambda (params) expr)");
      }
      Object paramsObj = lst.get(1);
      if (!(paramsObj instanceof ArrayList)) {
        throw new RuntimeException("lambda: paramètres doivent être une liste entre parenthèses");
      }
      ArrayList<Object> paramsListe = (ArrayList<Object>)paramsObj;
      ArrayList<String> params = new ArrayList<String>(); // liste des noms des paramètres
      for (Object p : paramsListe) {
        if (!(p instanceof String)) {
          throw new RuntimeException("lambda: paramètres doivent être des symboles");
        }
        params.add((String)p);
      }
      ArrayList<Object> bodySequence = new ArrayList<Object>();
      // ajoute tous les éléments après params dans le body
      for (int i = 2; i < lst.size(); i++) {
        bodySequence.add(lst.get(i));
      }
      // enveloppe le body dans un (begin ...) implicite (pour éviter des confusions pendant la programmation)
      ArrayList<Object> beginBody = new ArrayList<Object>();
      beginBody.add("begin");
      beginBody.addAll(bodySequence);
      return new Fonction(params, beginBody, env);
    }
  }

  // ---------
  // Appel de fonction si ce n'est pas un opérateur de base
  // ---------
  Fonc op;
  if (operateur instanceof String) {
    op = (Fonc)env.find((String)operateur).get(operateur); // le récupérer dans la hashmap de l'environnement
  } else if (operateur instanceof Fonction) {
    op = (Fonc)operateur; // Si c'est déjà une fonction
  } else {
    throw new RuntimeException("Pas une fonction : " + operateur);
  }

  ArrayList<Object> args = new ArrayList<Object>();
  for (int i = 1; i < lst.size(); i++) {
    args.add(lispEval(lst.get(i), env)); // collecte les arguments de la fonction (et les évalue s'ils sont eux-même des fonctions)
  }

  return op.apply(args, env); // executer et renvoyer le résultat
}

/**
 * Évalue une expression Lisp donnée sous forme de chaine de charactère.
 * Utilisé par la commande 'lisp' dans le Terminal.
 */
Object lispEval(String expression, Env env) {
  Object ast = parse(expression);
  return lispEval(ast, env);
}

/*
 * Charge l'environnement standard (comme stdlib en c mais avec moins de truc et ils sont plus importants)
 */
Env lispStandardEnv(Terminal currentLispTerminal) {
  Env env = new Env(); // nouvel environnement

  // opérateurs numériques
  env.put("+", (Fonc) (args, e) -> {
    float sum = 0;
    for (Object x : args) {
      sum += ((Number)x).floatValue();
    }
    return sum;
  }
  );
  env.put("-", (Fonc) (args, e) -> ((Number)args.get(0)).floatValue() - ((Number)args.get(1)).floatValue());
  env.put("*", (Fonc) (args, e) -> {
    float prod = 1;
    for (Object x : args) {
      prod *= ((Number)x).floatValue();
    }
    return prod;
  }
  );
  env.put("/", (Fonc) (args, e) -> ((Number)args.get(0)).floatValue() / ((Number)args.get(1)).floatValue());
  env.put(">", (Fonc) (args, e) -> ((Number)args.get(0)).floatValue() > ((Number)args.get(1)).floatValue());
  env.put("<", (Fonc) (args, e) -> ((Number)args.get(0)).floatValue() < ((Number)args.get(1)).floatValue());
  env.put(">=", (Fonc) (args, e) -> ((Number)args.get(0)).floatValue() >= ((Number)args.get(1)).floatValue());
  env.put("<=", (Fonc) (args, e) -> ((Number)args.get(0)).floatValue() <= ((Number)args.get(1)).floatValue());
  env.put("=", (Fonc) (args, e) -> ((Number)args.get(0)).floatValue() == ((Number)args.get(1)).floatValue());
  // des fonctions probablement utiles
  env.put("abs", (Fonc) (args, e) -> Math.abs(((Number)args.get(0)).floatValue()));
  env.put("sqrt", (Fonc) (args, e) -> Math.sqrt(((Number)args.get(0)).floatValue()));
  env.put("sin", (Fonc) (args, e) -> Math.sin(((Number)args.get(0)).floatValue()));
  env.put("cos", (Fonc) (args, e) -> Math.cos(((Number)args.get(0)).floatValue()));
  env.put("tan", (Fonc) (args, e) -> Math.tan(((Number)args.get(0)).floatValue()));
  env.put("max", (Fonc) (args, e) -> Math.max(((Number)args.get(0)).floatValue(), ((Number)args.get(1)).floatValue()));
  env.put("min", (Fonc) (args, e) -> Math.min(((Number)args.get(0)).floatValue(), ((Number)args.get(1)).floatValue()));
  env.put("round", (Fonc) (args, e) -> Math.round(((Number)args.get(0)).floatValue()));

  // listes
  env.put("length", (Fonc) (args, e) -> ((ArrayList)args.get(0)).size());
  env.put("append", (Fonc) (args, e) -> {
    ArrayList<Object> a = new ArrayList<Object>((ArrayList<Object>)args.get(0));
    Object b = args.get(1);
    if (b instanceof ArrayList) {
      a.addAll((ArrayList<Object>)b);
    } else {
      a.add(b);
    }
    return a;
  }
  );
  env.put("list", (Fonc) (args, e) -> new ArrayList<Object>(args));
  env.put("list?", (Fonc) (args, e) -> args.get(0) instanceof ArrayList); // savoir si c'est une liste
  env.put("car", (Fonc) (args, e) -> ((ArrayList<Object>)args.get(0)).get(0)); // premier élément
  env.put("cdr", (Fonc) (args, e) -> ((ArrayList<Object>)args.get(0)).subList(1, ((ArrayList<Object>)args.get(0)).size())); // la liste sans le premier élément
  env.put("cons", (Fonc) (args, e) -> { // paire
    ArrayList<Object> L = new ArrayList<Object>();
    L.add(args.get(0));
    if (args.get(1) instanceof ArrayList) {
      L.addAll((ArrayList<Object>)args.get(1));
    } else {
      L.add(args.get(1));
    }
    return L;
  }
  );
  env.put("null?", (Fonc) (args, e) -> ((ArrayList<Object>)args.get(0)).isEmpty()); // est-ce que la liste est vide ?

  // appliquer une fonctions à une liste
  env.put("apply", (Fonc) (args, e) -> {
    Fonc Fonc = (Fonc)args.get(0);
    ArrayList<Object> arglist = (ArrayList<Object>)args.get(1);
    return Fonc.apply(arglist, e);
  }
  );
  // logique / booléens
  env.put("not", (Fonc) (args, e) -> !(Boolean)args.get(0));
  env.put("eq?", (Fonc) (args, e) -> args.get(0) == args.get(1));
  env.put("equal?", (Fonc) (args, e) -> args.get(0).equals(args.get(1)));
  env.put("symbol?", (Fonc) (args, e) -> args.get(0) instanceof String); // est un texte ?
  env.put("number?", (Fonc) (args, e) -> args.get(0) instanceof Number);

  // output du texte dans la console
  env.put("display", (Fonc) (args, e) -> {
    Terminal t = currentLispTerminal;
    if (t != null) {
      String s = args.get(0).toString();
      if (s.length() >= 2 && s.startsWith("\"") && s.endsWith("\"")) {
        s = s.substring(1, s.length() - 1);
      }
      t.texte += s;
    } else {
      println(args.get(0)); // print dans le debug si pas de terminal
    }
    return null;
  }
  );

  env.put("newline", (Fonc) (args, e) -> { // ligne vide
    Terminal t = currentLispTerminal;
    if (t != null) {
      t.texte += "\n";
    } else {
      println();
    }
    return null;
  }
  );

  // bloc de programme
  env.put("begin", (Fonc) (args, e) -> args.get(args.size()-1));

  // quitter le système
  env.put("shutdown", (Fonc) (args, e) -> {
    exit();
    return null;
  }
  );

  // commande run pour éxécuter les commandes normales du terminal
  env.put("run", (Fonc) (args, e) -> {
    Terminal t = currentLispTerminal;

    if (args.isEmpty()) {
      throw new RuntimeException("run: besoin d'une commande");
    }

    String cmdName = args.get(0).toString();

    if (cmdName.length() >= 2 &&
      cmdName.startsWith("\"") &&
      cmdName.endsWith("\"")) {
      cmdName = cmdName.substring(1, cmdName.length() - 1);
    }

    String[] cmdArgs = new String[args.size() - 1];
    for (int i = 1; i < args.size(); i++) {
      String raw = args.get(i).toString();  // par exemple "\"test.lisp\""
      String cleaned = raw;

      // enlever les guillemets autour
      if (cleaned.length() >= 2 &&
        cleaned.startsWith("\"") &&
        cleaned.endsWith("\"")) {
        cleaned = cleaned.substring(1, cleaned.length() - 1);
      }

      cmdArgs[i - 1] = cleaned;
    }

    Commande cmd = t.commandes.get(cmdName);
    if (cmd == null) {
      throw new RuntimeException("run: commande inconnue " + cmdName);
    }

    cmd.executer(cmdArgs, t);
    return null;
  }
  );

  return env;
}
