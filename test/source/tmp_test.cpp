#include "project/tmp.hpp"

#include <gtest/gtest.h>

TEST(TmpAddTest, 值校验) {
  ASSERT_EQ(tmp::add(1, 2), 3);
  EXPECT_TRUE(true);
}

auto main(int argc, char* argv[]) -> int {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
