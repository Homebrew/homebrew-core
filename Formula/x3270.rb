class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga9-src.tgz"
  sha256 "5f0c0c3783f50a3e9858675983a521fb56039bf36243229715ffae8e200d2806"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8654a01ac470ffb0e43946a6631de41b3164526040e53c374761858120858f1d"
    sha256 arm64_monterey: "c38e5bae4a42bbe81896d090e4fe64761913e45ad0e8bccdba106f2e01cac2f6"
    sha256 arm64_big_sur:  "f1b8b5c356ace7f23b4f7f576397b08a60dcab50532d0e932a9aa2087ae81bda"
    sha256 ventura:        "506c05fa1bf3760594537d60b21d5f614ce3efde032047b5ee8e5004e90f2142"
    sha256 monterey:       "cc49e00b69572ddcda7516c653cd64c1828c3b58df22df840dd6af634132573f"
    sha256 big_sur:        "50b263df5bdefa2507622f279e0e88875e1e744c5f6fc8f1bf677e8d268d9419"
    sha256 x86_64_linux:   "1bc4d99a3c351ff9fe74c81f32c0a4c67de79819002ffe7199fce8be994a4984"
  end

  depends_on "readline"

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
