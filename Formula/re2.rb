class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-05-01.tar.gz"
  version "20200501"
  sha256 "88864d7f5126bb17daa1aa8f41b05599aa6e3222e7b28a90e372db53c1c49aeb"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "430e7efee518f5235ea75afc039168ce38c5407b525301199ccbc6c698300bb8" => :catalina
    sha256 "67eed1f38907d1d7318b5d95f035ca18ff6186d85ee690560b8b1cd387f8afd4" => :mojave
    sha256 "f111b7c906ab090d9db56e1f183f94d02e8cf5ce521e4ae4ff8e64d974cb5cbb" => :high_sierra
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.7.0.0.dylib", "#{lib}/libre2.0.dylib")
    lib.install_symlink "libre2.7.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.7.0.0.dylib" => "libre2.dylib"
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
