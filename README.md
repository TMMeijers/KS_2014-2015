# KS_2014-2015
Kennissystemen 2014-2015

### Assignment 1

#### Semantic Networks and Frames

For this assignment we will use the domain of animals. You can use Wikipedia as a source of inspiration.

The domain should consist of at least 10 animals (e.g. ‘aap’, ‘kat’, ‘ vis’, etc.) and animals should have at least 5 features (e.g. ‘voortplanting’, ‘lichaamstemperatuur’, ‘aantal_poten’).

Construct a knowledge base for this domain using a KL-ONE like representation (read the appropriate article in the Reader!). It should include frames and inheritance. Using frames means that the attributes of a single concept are somehow clustered and this cluster can be seen as a concept description. Inheritance means that the concepts are organised in a 'subtype' hierarchy and that common features are only represented once for a group of concepts. This probably requires the introduction of intermediate concepts, e.g.:

    ‘zoogdier’, ‘amfibie’, etc.
    or: ‘dier_met_vleugels’ and ‘dier_zonder_vleugels’, etc.
    or: ‘warmbloedige_dieren’ and ‘koudbloedige_dieren’, etc.

 1. Make a drawing that depicts the concept hierarchy (use a digital drawing tool) of all the generic concepts that you will use (that is for the full domain of at least 10 animals not counting the intermediate ones). Your artistic qualities are not graded, so do not spend too much time on this part...

2. Determine what kind of representation in Prolog is required and implement the generic knowledge base including 5 of the 10 generic concepts describing animals. For the representation, use the idea of attributes (roles), value restrictions (v/r), and number restrictions (n/r) as discussed for KL-ONE.

3. Construct a pretty-print routine that writes the contents of the knowledge-base to the screen and call this procedure: 'show'.

4. Construct a classifier (see KL-ONE) that adds/places new generic concepts (describing animals) to the knowledge base. Use the remaining 5 concepts to show that your program works correctly. Create 5 shortcuts (go1, go2, go3, go4, and go5) that take a previously stored set of attributes and values and adequately place (assert) the 'generic concept' in the existing concept hierarchy. Show at least the following features:

a. A fully new concept (one without super concepts, e.g. you have defined animals and add a concept 'plant');

b. A fully subsumed concept (all attributes and values match an existing concept, e.g. you have defined a mammal with three attributes/values and add a concept 'ape' with these three attributes/values plus one new attribute/value);

c.  A concept with missing attributes/values which is placed in the hierarchy while adding the missing knowledge to the concept (Example: Add a concept 'gorilla' with property 'is_a mammal' and some other attributes/values. Properties of class 'mammal' must now be shown as well when 'show(gorilla).' is called). Make use of inheritance!
Note that you can only classify a concept as a specific type of another concept if an is_a-relation is a given fact, or if ALL attributes/values match (fully subsumed)!

N.B: In fact it would be handy to distinguish 'classes' from 'individuals' (or instances) of these classes. In the last example you could assert an individual monkey and have the system describe its attributes and values.

Submit before the deadline (see schedule) both the drawing and the (documented!) code.
