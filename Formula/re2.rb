class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/releases/download/2023-07-01/re2-2023-07-01.tar.gz"
  version "20230701"
  sha256 "18cf85922e27fad3ed9c96a27733037da445f35eb1a2744c306a37c6d11e95c4"
  license "BSD-3-Clause"
  head "https://github.com/google/re2.git", branch: "main"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYYMMDD format used in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^(\d{2,4}-\d{2}-\d{2})$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub(/\D/, "") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f4ecaa1791c7f11a211e654e67739e01d288f518c4d418d1c54bab7abc7732d5"
    sha256 cellar: :any,                 arm64_monterey: "c9883aaef3842f615615c2ce0583e0ecd7028d707cda50519824fad425feb3d1"
    sha256 cellar: :any,                 arm64_big_sur:  "16480dd04be1ae01931e79fc128bf7b9134fc74d55b4b8772962374d58e49657"
    sha256 cellar: :any,                 ventura:        "9d5586ab72468844b1e06184ad3ffa0786583ac5914f6a4d3658e711a135f50e"
    sha256 cellar: :any,                 monterey:       "ba458833a57e7331b4327cfa240d4b8345717a5feca4d429c5c300d213700c0f"
    sha256 cellar: :any,                 big_sur:        "c30b2eac18c9c8be9c93a026817f30fb1e575c09a5ea2a6462ed5fc0ca64cf05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78bc4b5d082ce350f92ef431e73253e5cbdb0bec5c7783db2a816e9ada27a323"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

  def install
    # Build and install static library
    system "cmake", "-S", ".", "-B", "build-static",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-static"
    system "cmake", "--install", "build-static"

    # Build and install shared library
    system "cmake", "-S", ".", "-B", "build-shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end
