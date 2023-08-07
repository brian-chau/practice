#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include <iostream>

#include "Solution.h"

// The fixture for testing class Solution. From google test primer.
class SolutionTest : public ::testing::Test {
protected:
    // You can remove any or all of the following functions if its body
    // is empty.

    SolutionTest() {
        // You can do set-up work for each test here.
        fails = 0;
    }

    virtual ~SolutionTest() {
        // You can do clean-up work that doesn't throw exceptions here.
    }

    // If the constructor and destructor are not enough for setting up
    // and cleaning up each test, you can define the following methods:
    virtual void SetUp() {
        // Code here will be called immediately after the constructor (right
        // before each test).
    }

    virtual void TearDown() {
        // Code here will be called immediately after each test (right
        // before the destructor).
        if (fails > 0) {
            fprintf(stderr, "TEST FAILED! %u failures found!\n", fails);
        }
    }

    // Objects declared here can be used by all tests in the test case for
    // Solution.
    Solution s;
    unsigned fails;
};

// Test case must be called the class above
// Also note: use TEST_F instead of TEST to access the test fixture (from google
// test primer)

TEST_F(SolutionTest, Numbers1) {
    int actualResult(s.ReturnOne());
    int expectedResult(1);
    EXPECT_EQ(actualResult, expectedResult);
    fails += ::testing::Test::HasFailure();
}

TEST_F(SolutionTest, Numbers2) {
    int actualResult(s.ReturnOne());
    int expectedResult(1);
    EXPECT_THAT(actualResult, testing::Not(expectedResult));
    fails += ::testing::Test::HasFailure();
}

// }  // namespace - could surround SolutionTest in a namespace