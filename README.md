# PMML to Javascript (pmml2js) - decision tree with CompoundPredicates (v4.3)
## Generieren von Javascript-Code aus dem PMML
- PMML in den Ordner `pmml2js_with_compound_v_4_3` als `pmml.xml`kopieren
- `pmml2js.html` im Browser öffnen (getestet in Safari)
- Content des Browsers entspricht dem Entscheidungsbaum auf Javascript Code-Basis und kann in folgendem Code (von artistoex <http://stackoverflow.com/questions/8368698/how-to-implement-a-decision-tree-in-javascript-looking-for-a-better-solution-th/8369235#8369235>) verwendet werden:




```
DecisionTree = function (predicate, action) {
    this.predicate = predicate;
    this.action = action;
};

DecisionTree.prototype = {
    nomatch : { match : false },
    match : function (v) { return { match : true, result :v }; },
    name: "Decision Tree" ,

    // Recursively test DecisionTrees and applies corresponding action on
    // `object`.
    // The action applied depends on the datatype of `action`:
    // - Function : evaluates to `action( object )`
    // - DecisionTree : A subsequent test is performed.  Evaluates to whatever the DecisionTrees action evaluates to.
    // - Array of DecisionTrees : Subsequent tests are performed.  Evaluates to whatever the action of the first matching DecisionTree evaluates to.
    // - Any other Value : Evaluates to itself
    // returns object containing fields:
    //     match:  boolean, indicates if DecisionTree was a match
    //     result:  result of action applied
    evaluate : function( object ) {
        var match = this.predicate;

        if ( match instanceof Function )
            match = match( object );

        if ( match ) {

            if (this.action instanceof Function )
                return this.match( this.action(object) );

            if ( this.action instanceof DecisionTree )
                return this.action.evaluate( object );

            if ( this.action instanceof Array ) {
                var decision;
                var result;
                for (var c = 0; c < this.action.length; c++ ) {
                    decision = this.action[c];
                    if ( decision instanceof DecisionTree )  {
                        result = decision.evaluate( object );
                        if (result.match)
                            return result;
                    } else throw("Array of DecisionTree expected");
                }

                return this.nomatch;
            }

            return this.match(this.action);
        }
        return this.nomatch;
    }
};

export const decisionTree = GENERATED_PMML2JS_CODE_HERE


```



