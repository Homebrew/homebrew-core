class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.1.2.tar.gz"
  sha256 "383560d6b00697c04e8878e26c0187b480971a8bce90ffd26a5a7b0f7ecf1a33"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7443f30d8fe6b021739fe4c818fef45cabef9752d5f58c3dd33f6058973998a0"
    sha256 cellar: :any,                 arm64_monterey: "332ddb9fb41ca459749e0e0b1042e2a84fe44dc99150d316910a0e56a5f73773"
    sha256 cellar: :any,                 arm64_big_sur:  "74bd2d6106d1f8a4ae07a2887dbaece99dce21e2dfe3e50b6499fde2f4f629e4"
    sha256 cellar: :any,                 ventura:        "6f23712a56e1c07f9ec39c77d20bf7817d3abaf2e9f7bf3caea6073c5734a2cd"
    sha256 cellar: :any,                 monterey:       "64ee46dc54eff60c971b4c015f3b881f2974ef2fed758de2cbe1b32cc68cc9f3"
    sha256 cellar: :any,                 big_sur:        "278a57bcad4a6a6d8afec58172a5cf22829abdaabb56cb7f29ac68c4014f583d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c619f2fb292bbe282354320decb442c52fd0f4bd8f40c6b43999efa87c6d98"
  end

  # https://zlib.net/zlib_how.html
  resource "homebrew-test_artifact" do
    url "https://zlib.net/zpipe.c"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test uses an example of code for zlib and overwrites its API with zlib-ng API
    testpath.install resource("homebrew-test_artifact")
    inreplace "zpipe.c", "#include \"zlib.h\"", <<~EOS
      #include "zlib-ng.h"
      #define inflate     zng_inflate
      #define inflateInit zng_inflateInit
      #define inflateEnd  zng_inflateEnd
      #define deflate     zng_deflate
      #define deflateEnd  zng_deflateEnd
      #define deflateInit zng_deflateInit
      #define z_stream    zng_stream
    EOS

    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz-ng", "-o", "zpipe"

    content = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", content)
    assert_equal content, pipe_output("./zpipe -d", compressed)
  end
end
