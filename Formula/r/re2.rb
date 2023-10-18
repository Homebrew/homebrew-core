class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/releases/download/2023-09-01/re2-2023-09-01.tar.gz"
  version "20230901"
  sha256 "5bb6875ae1cd1e9fedde98018c346db7260655f86fdb8837e3075103acd3649b"
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
    sha256 cellar: :any,                 arm64_sonoma:   "ab962062c76bc1172e155886d636dcf085e034b756df5143ef792726b4bb9699"
    sha256 cellar: :any,                 arm64_ventura:  "f1a44f5622d8d2d93dac473b561c8bbc750ebfd9ff9f3f9959cdee5798101cec"
    sha256 cellar: :any,                 arm64_monterey: "6dd073dc3f3de813bdabf824153b8f2171022f1996054a02632823722057b6c4"
    sha256 cellar: :any,                 arm64_big_sur:  "87ffb37601588d8b68e3221d97c2bff6cc8573ad8e9fa081b44f72afc5b969d2"
    sha256 cellar: :any,                 sonoma:         "3f85a5c00b9a6c2abe2f57fb6c3f54c78ae4b842b64f6bb6707165abda5885d5"
    sha256 cellar: :any,                 ventura:        "9afde349d641645a25b23b360ed940b1fb4d1096785257aa7408badb784b283d"
    sha256 cellar: :any,                 monterey:       "075c018d1419a2de0f4fb5bebd35171b7db4a2087d7d6233298ad24151f8a9c6"
    sha256 cellar: :any,                 big_sur:        "e3dea5a69f82faf074184cea9fc0481e01056cfca851fe6d548e105b339d4afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39dea1be3b98596596044f7a13e4ba683e4f6466a422a9cce410ba806d51a1f"
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
