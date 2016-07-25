class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2016-07-01.tar.gz"
  version "20160701"
  sha256 "06c8c99c7c7b4bb869e088c007d4162b4f302ab55671880333d01eff63997626"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "917546580bed4d2f8e60531a93ddc3cd5001be66100ffe52c862a31d30b1067b" => :el_capitan
    sha256 "3b75d5e178a745d21e338e9ab54f373dc81f4c3a85bce08e8e6f47f0f259b94e" => :yosemite
    sha256 "091c858f09f468f04b964f5b8986a85c0e4eb2b0c458502e96382a81b330e0f7" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
    system "install_name_tool", "-id", "#{lib}/libre2.0.dylib", "#{lib}/libre2.0.0.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lre2",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
