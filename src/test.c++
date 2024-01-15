// Let Catch provide main():
#define CATCH_CONFIG_MAIN

#include <catch.hpp>

#include "ramC.h"
#include <iostream>

double const pi = acos(-1);

TEST_CASE("set/get") {
    RAMBOC R;
    R.setN(2);
    REQUIRE(R.getN() == 2);
    R.setN(3);
    REQUIRE(R.getN() == 3);
    R.setECM(10.);
    REQUIRE(R.getECM() == 10.);
    R.setMass(0, 1.);
    R.setMass(1, 2);
    REQUIRE(R.getMass(0) == 1.);
    REQUIRE(R.getMass(1) == 2.);
}

//******************************************************************************
//****************      Momentum Conservation ***********************************
//******************************************************************************

TEST_CASE("Momentum conservation, 4 final particles") {
    for (int n = 2; n <= 8; ++n) {
        RAMBOC R;
        R.setN(n);
        double M = 0;
        for (int i = 0; i < n; ++i) {
            R.setMass(i, 0.1 * (i + 1));
            M += 2 * 0.1 * (i + 1);
        }
        R.setECM(M);
        R.next();
        EvtVector4R P;
        for (int i = 0; i < n; ++i) {
            REQUIRE(R.getV(i).mass() == Approx(0.1 * (i + 1)));
            P += R.getV(i);
        }
        REQUIRE(P.get(0) == Approx(M));
        REQUIRE(P.get(1) == Approx(0).margin(1e-3));
        REQUIRE(P.get(2) == Approx(0).margin(1e-3));
        REQUIRE(P.get(3) == Approx(0).margin(1e-3));
    }
}

//******************************************************************************
//****************      Zero LIPS  ***********************************
//******************************************************************************

int factorial(int i) {
    if (i <= 0) return 1;
    else return i * factorial(i - 1);
}

TEST_CASE("LIPS0") {
    for (int n = 2; n <= 8; ++n) {
        double M = 1;
        RAMBOC R;
        R.setN(n);
        R.setECM(M);
        for (int i = 0; i < n; ++i) {
            R.setMass(i, 0);
        };
        int nEv = 1e3;
        double sum = 0;
        for (int i = 0; i < nEv; ++i) {
            sum += R.next();
        };
        sum /= nEv;
        REQUIRE(sum == Approx(pow(pi / 2, n - 1) / factorial(n - 1) / factorial(n - 2) * pow(M*M, n - 2)).margin(1e-3));
    }
}


TEST_CASE("Muon decay") {
    using namespace std;
    double XM[] = {0, 0, 0};
    double const mMu = 0.1056;
    double GF = 1;
    RAMBOC R(3, mMu, XM);
    double sum = 0;
    int nEv = 1e5;
    for (int iEv = 0; iEv < nEv; ++iEv) {
        double wt = R.next();
        wt *= pow(2 * pi, 4 - 3 * 3);
        EvtVector4R k = R.getV(0);
        EvtVector4R q1 = R.getV(1);
        EvtVector4R q2 = R.getV(2);
        EvtVector4R p = k + q1 + q2;
        double mtr2 = 128 * pow(GF, 2)*(p * q1)*(k * q2);
        sum += mtr2*wt;
        if (iEv < 0) {
            cout << " Debug print at iEv=" << iEv << " =========== " << endl;
            cout << " k = " << k << "; m2 = " << k.mass2() << endl;
            cout << " q1 = " << q1 << "; m2 = " << q1.mass2() << endl;
            cout << " q2 = " << q2 << "; m2 = " << q2.mass2() << endl;
            cout << " p = " << p << "; m = " << p.mass() << endl;
        }
    };
    sum /= nEv;
    double gamma = 1. / 2 / (2 * mMu) * sum;
    double gamma0 = GF * GF * pow(mMu, 5) / (192 * pow(pi, 3));
    REQUIRE(gamma / gamma0 == Approx(1).margin(0.01));
}

TEST_CASE("M0") {
    double M = 2, m = 1, M2 = M*M, m2 = m*m;
    // n = 2
    RAMBOC R(M, m, 0);
    double sum = 0;
    int nEv = 1e5;
    for (int iEv = 0; iEv < nEv; ++iEv) {
        sum += R.next() * pow(2 * pi, 4 - 3 * 2) / nEv;
    };
    double sum_0 = (1 - m2 / M2) / (8 * pi);
    REQUIRE(sum / sum_0 == Approx(1));

};

TEST_CASE("M00") {
    double M = 2, m = 1, M2 = M*M, m2 = m*m;
    RAMBOC R(M, m, 0, 0);
    double sum = 0;
    int nEv = 1e6;
    for (int iEv = 0; iEv < nEv; ++iEv) {
        sum += R.next() * pow(2 * pi, 4 - 3 * 3) / nEv;
    };
    double sum_0 = -(pow(m2, 2) - pow(M2, 2) + 2 * m2 * M2 * log(M2 / m2)) / (256. * M2 * pow(pi, 3));
    REQUIRE(sum / sum_0 == Approx(1).margin(0.05));
};

TEST_CASE("M000") {
    double M = 2, m = 1, M2 = M*M, m2 = m*m;
    RAMBOC R(M, m, 0, 0, 0);
    double sum = 0;
    int nEv = 1e6;
    for (int iEv = 0; iEv < nEv; ++iEv) {
        sum += R.next() * pow(2 * pi, 4 - 3 * 4) / nEv;
    };
    double sum_0 = -(((m2 - M2)*(pow(m2, 2) + 10 * m2 * M2 + pow(M2, 2))) / (6. * M2) + m2 * (m2 + M2) * log(M2 / m2)) / (4096. * pow(pi, 5));
    REQUIRE(sum / sum_0 == Approx(1).margin(0.05));
};

TEST_CASE("M0000") {
    double const M = 2, m = 1, M2 = M*M, m2 = m*m;
    RAMBOC R(M, m, 0, 0, 0, 0);
    double sum = 0;
    int nEv = 1e6;
    for (int iEv = 0; iEv < nEv; ++iEv) {
        sum += R.next() * pow(2 * pi, 4 - 3 * 5) / nEv;
    };
    double sum_0 = (-pow(m2, 4) - 28 * pow(m2, 3) * M2 + 28 * m2 * pow(M2, 3)
            + pow(M2, 4) + 12 * m2 * M2 * (pow(m2, 2) + 3 * m2 * M2 + pow(M2, 2)) * log(m2 / M2)) /
            (4.718592e6 * M2 * pow(pi, 7));
    REQUIRE(sum / sum_0 == Approx(1).margin(0.05));
};

