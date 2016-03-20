package {

        import citrus.core.CitrusEngine;

        import games.osmos.OsmosGameState;

        [SWF(frameRate="60")]

        /**
        * @author Aymeric
        */
        public class Main extends CitrusEngine {

                public function Main() {

                        // copy & paste here the Main class of the differents src project, be careful with the package & import!
                        // you may need the external libraries in the lib folder to run the demo.

                        // If you wish to use Starling, the Main class must extends StarlingCitrusEngine!
                        //setUpStarling(true);

                        state = new OsmosGameState();
                }
        }
}