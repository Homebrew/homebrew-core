class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2022-12-01.tar.gz"
  version "20221201"
  sha256 "665b65b6668156db2b46dddd33405cd422bd611352c5052ab3dae6a5fbac5506"
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
    sha256 cellar: :any,                 arm64_ventura:  "80993d374f3bbef9856a547c695937a32454f153e5b0ac069aca2d7aaec8aded"
    sha256 cellar: :any,                 arm64_monterey: "7004cc4a847029684c3ed9bc3c46cca9ddbe7973c553742bef8b84987b137d1c"
    sha256 cellar: :any,                 arm64_big_sur:  "cb365f2a6137288ebbbd2313dbb78698d68e0c8a2d083b82fc268cdb3336175a"
    sha256 cellar: :any,                 ventura:        "ebaef84e3cb05be02389fb9d9327c36d5b18559b57138e922cc920fd457a6181"
    sha256 cellar: :any,                 monterey:       "99f73fbbcce0b9600541c374f9f22ce509f62d087db2f3b8def42836a9a864cd"
    sha256 cellar: :any,                 big_sur:        "8eed885dba41e2328f1780b383021aba6c90799e8a2bb4c7b14c43254a05dc9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c48e4f8de8471df08782f95333788a0db74a6aa7e8bcb524a49d57662c8904"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    # Run this for pkg-config files
    system "make", "common-install", "prefix=#{prefix}"

    # Build and install static library
    system "cmake", "-B", "build-static", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make", "-C", "build-static"
    system "make", "-C", "build-static",  "install"

    # Build and install shared library
    system "cmake", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make", "-C", "build-shared"
    system "make", "-C", "build-shared", "install"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end
