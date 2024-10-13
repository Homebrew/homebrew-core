class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga9-src.tgz"
  sha256 "6404d27b29a40d896daab35ff153cab157d85094b38bdeb4ebaaaf2673ce4db1"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "71e53c693ce7cd9f487526df27c6c9c7464420bd32239f1a1b72b9ae7f3c8839"
    sha256 arm64_sonoma:   "a73dbd7599c2dfa7535c0f53868622863f71423f0ee61eb4fc9358098d0d8cb2"
    sha256 arm64_ventura:  "aa9b6a05284b8f991f128016b8fad45bd48546ffebe24149fce1e76d28d7821a"
    sha256 arm64_monterey: "c51104f8fa4adfd6c4e8a0ab976e728a1345072e870044b13b825127cba4c10b"
    sha256 sonoma:         "fb399eb24bcf2d7cbb7e1d7476c08ba4385a612b4fcda19e0d5f90a0b649270b"
    sha256 ventura:        "7dcc9f728a4dcc5cca53d2aa6c5dafc1b744c274b784b3378e6287d49f18230b"
    sha256 monterey:       "0362f8daef1203d3a0e4e34393da6c3156afb317a95040ef1a0aebc7a4ea36ef"
    sha256 x86_64_linux:   "0dc43a7f7f26c1118769ef4c4f4c4f09fabeeaacd7d77b9a1fd7ef7a03ad63a2"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "ncurses"
  uses_from_macos "tcl-tk"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk"].opt_include}/tcl-tk" unless OS.mac?

    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
