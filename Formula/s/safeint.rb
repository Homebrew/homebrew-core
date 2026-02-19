class Safeint < Formula
  desc "Class library for C++ that manages integer overflows"
  homepage "https://github.com/dcleblanc/SafeInt"
  url "https://github.com/dcleblanc/SafeInt/archive/refs/tags/3.0.28a.tar.gz"
  version "3.0.28a"
  sha256 "9e652d065a3cef80623287d5dc61edcf6a95ddab38a9dfeb34f155261fc9cef7"
  license "MIT"
  head "https://github.com/dcleblanc/SafeInt.git", branch: "master"

  # The `GithubLatest` strategy is used here because upstream changed their
  # version numbering so that 3.0.26 follows 3.24.
  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ffba215daf83f5a8a3beffae5f56f6e58288ff1f7c9f35d52edf19db5e935663"
  end

  def install
    include.install %w[
      SafeInt.hpp
      safe_math.h
      safe_math_impl.h
    ]
  end

  test do
    # Modified from:
    #   https://learn.microsoft.com/en-us/cpp/safeint/safeint-class?view=msvc-170#example
    (testpath/"test.cc").write <<~CPP
      #ifdef NDEBUG
      #undef NDEBUG
      #endif
      #include <assert.h>

      #include <SafeInt.hpp>

      int main() {
        int divisor = 3;
        int dividend = 6;
        int result;

        bool success = SafeDivide(dividend, divisor, result); // result = 2
        assert(result == 2);
        assert(success);

        success = SafeDivide(dividend, 0, result); // expect fail. result isn't modified.
        assert(result == 2);
        assert(!success);
      }
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "-o", "test", "test.cc"
    system "./test"
  end
end
