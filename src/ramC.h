#ifndef RAMC
#define RAMC

//#include "CLHEP/Vector/LorentzVector.h"
#include "EvtGenBase/EvtVector4R.hh"
#include "TRandom.h"

class RAMBOC {
public:

    RAMBOC() {
    };

    /** RAMBOC(n, ecm, XM)
     * 
     * Constructor
     * 
     * @param integer n number of final particles (2<=n<=5)
     * @param double ecm Mass of the decaying particle
     * @param double XM[n] masses of the final particles
     */
    RAMBOC(int n, const double ecm, double xm[]);

    /** RAMBOC(ecm, m1, m2)
     * 
     * 2-body constructor
     * 
     * @param double ecm Mass of the decaying particle
     * @param double m1 Mass of the 1st daughter particle
     * @param double m2 Mass of the 2nd daughter particle
     */
    RAMBOC(double ecm, double m1, double m2);

    /** RAMBOC(ecm, m1, m2, m3)
     * 
     * 3-body constructor
     * 
     * @param double ecm Mass of the decaying particle
     * @param double m1 Mass of the 1st daughter particle
     * @param double m2 Mass of the 2nd daughter particle
     * @param double m3 Mass of the 3rd daughter particle
     */
    RAMBOC(double ecm, double m1, double m2, double m3);

    /** RAMBOC(ecm, m1, m2, m3, m4)
     * 
     * 4-body constructor
     * 
     * @param double ecm Mass of the decaying particle
     * @param double m1 Mass of the 1st daughter particle
     * @param double m2 Mass of the 2nd daughter particle
     * @param double m3 Mass of the 3rd daughter particle
     * @param double m4 Mass of the 4th daughter particle
     */
    RAMBOC(double ecm, double m1, double m2, double m3, double m4);
    
    /** RAMBOC(ecm, m1, m2, m3, m4, m5)
     * 
     * 5-body constructor
     * 
     * @param double ecm Mass of the decaying particle
     * @param double m1 Mass of the 1st daughter particle
     * @param double m2 Mass of the 2nd daughter particle
     * @param double m3 Mass of the 3rd daughter particle
     * @param double m4 Mass of the 4th daughter particle
     * @param double m5 Mass of the 5th daughter particle
     */
    RAMBOC(double ecm, double m1, double m2, double m3, double m4, double m5);
    
    RAMBOC(double ecm, double m1, double m2, double m3, double m4, double m5, double p6);
    
    RAMBOC(double ecm, double m1, double m2, double m3, double m4, double m5, double p6, double p7);
    
    RAMBOC(double ecm, double m1, double m2, double m3, double m4, double m5, double p6, double p7,  double p8);

    
    /** next()
     * 
     * generates next event
     * 
     * @return the weight of the event (according to PDG definitions)
     */
    double next();

    /** getWT()
     * 
     * @return the weight of previously generated event (according to PDG definitions)
     */
    double getWT() {
        return WT;
    };

    /** getV(i)
     * 
     * @param i the number of the particle
     * @return the momentum of the i-th particle
     */
    EvtVector4R getV(int i);

    /** getECM()
     * 
     * @return the mass of the decaying particle
     */
    double getECM() {
        return ECM;
    };

    /** setECM(ecm)
     * 
     * @param ecm the mass of the decaying particle
     */
    void setECM(double ecm) {
        ECM = ecm;
    };

    /** getMass(i)
     * 
     * @param int i the number of the final particle
     * @return the mass of i-th particle
     */
    double getMass(int i) {
        return XM[i];
    };

    /** setMass(i, m)
     * 
     * 
     * @param int i the number of the final particle
     * @param double m the mass of the i-th particle
     */
    void setMass(int i, double m) {
        XM[i] = m;
    }

    /** getN()
     * 
     * @return int the number of final particles 
     */
    int getN() {
        return N;
    };

    /** setN(n)
     * 
     * @param int n the number of final particles
     */
    void setN(int n) {
        N = n;
    };

    /** setSeed(seed)
     * 
     * @param int seed seed of the random generator
     */
    void setSeed(int seed);

private:
    double N, ECM, XM[8], WT;
    EvtVector4R P1, P2, P3, P4, P5, P6, P7, P8;
    double p1[4], p2[4], p3[4], p4[4], p5[4], p6[4], p7[4], p8[4];
};

#endif
