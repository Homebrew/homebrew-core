class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga10-src.tgz"
  sha256 "db513225f074144a5a0221d57ede37cca1468c2c2d158ea09981f50012ebdbe7"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7df73eab24e5547706daad4246f289c1fa40ba3305c1bf80e422aec01c1dba9b"
    sha256 arm64_monterey: "845425476e87c63e66a423a06f9008ba3cbbfaa971e57a142a2b39b73feb9fab"
    sha256 arm64_big_sur:  "69f0aaef7d53ede209698d67d1b3effaa861f39522fb25b9c5369f00d7c90790"
    sha256 ventura:        "ce26eac24789c1c60e0a6644f3223596362b2b0d329ce4997682a1cf958d1ad2"
    sha256 monterey:       "1e610881544acca51d4a5c1858f830171fb97ffa40bc212b92a69c5cee80f1b4"
    sha256 big_sur:        "91bddbe156c20ec0f502962ccccfa86df3a7270768d63c6eab350577b7194613"
    sha256 x86_64_linux:   "df870b5a150c1f5291fa70990451017fb121e50a65ec93fd736d62018436e399"
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
