class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2019-07-01.tar.gz"
  version "20190701"
  sha256 "de6c3ee49b2cecdfd2936af18d6947db36726590e566b5915db3746784c55745"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "24fcae96249fc8e14b8579d3d916b2c952fe6aea51dcf3a40854a40aca7116f0" => :mojave
    sha256 "c130ece87ddc37102cef26c47e01a4b7c412ae0bdb32d8347e8b073891f362ac" => :high_sierra
    sha256 "650b1a9e3f1da497ca1b0d3942edd26101aca8127f0083b64686a2db210a47ca" => :sierra
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib")
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
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
