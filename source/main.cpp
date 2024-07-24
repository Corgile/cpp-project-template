//
// cpp-project-template / main.cpp
// Created by brian on 2024-07-25.
//

#include <iostream>
#include <project/tmp.hpp>

constexpr int ConstExpr = 5;

auto Fac(const int n) -> int {
  int ret = 1;
  for (int i = 1; i <= n; ++i) {
    ret *= i;
  }
  return ret;
}

static void FuncTion() {
  int facVar = 1;
  std::cout << " world!" << facVar;
  facVar = Fac(ConstExpr);
  std::cout << " world!" << facVar;
}

class SomeClass {
  SomeClass(const int x) : mHandle(x) {} // NOLINT(*-explicit-constructor)
  ~SomeClass() = default;
  int mHandle;
  /**
   * Get a readonly handle from SomClass.
   * @return const int&. immutable handle
   * @note 没有什么需要注意
   */
  auto getHandle() const -> int const& { return mHandle; }
  /**
   * Get a mutable handle from SomClass.
   * @return int& mutable handle
   */
  auto getHandle() -> int& { return mHandle; }
};

auto main() -> int {
  std::cout << "hello,";
  const int kSomeVar = Fac(4);
  FuncTion();
  std::cout << tmp::add(kSomeVar, 5) << '\n';
  return 0;
}
