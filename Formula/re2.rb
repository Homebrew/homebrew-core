class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-07-01.tar.gz"
  version "20170701"
  sha256 "e6f06ad87cdacbf4b5573481de78f0de609d6e9227028c80cae813751d834b1e"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "1a5ba0d547cc62d51f3a27e6dedbfdb706a12e4065eef64a0ba1dab9d86d7f61" => :sierra
    sha256 "91eb90a856183ef7dae756ff1a67e87694c19bc5ace9d3ea28c4865eedb1f138" => :el_capitan
    sha256 "2e26e1f6796f8fc98999f69d0f9c93109e18617df8becbbd2862f2870e5e4417" => :yosemite
  end

  needs :cxx11

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib")
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
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
