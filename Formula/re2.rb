class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-06-01.tar.gz"
  version "20200601"
  sha256 "fb8e0f4ed7a212e3420507f27933ef5a8c01aec70e5148c6a35313573269fae6"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "48ad8c2246404a35143979d581775732ab8b7fd36e4ce46bdd56161461ff3d76" => :catalina
    sha256 "c9f8b50a653058ad70414e0e2e3380e62627a536933de636fa0d3e3a85026a94" => :mojave
    sha256 "018cc829f15a4e1ce8db138bed45cda78b890ed9bb9b93916ce8a12d68d9ad59" => :high_sierra
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
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
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
