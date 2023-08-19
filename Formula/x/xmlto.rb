class Xmlto < Formula
  desc "Convert XML to another format (based on XSL or other tools)"
  homepage "https://pagure.io/xmlto/"
  url "https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2"
  sha256 "1130df3a7957eb9f6f0d29e4aa1c75732a7dfb6d639be013859b5c7ec5421276"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/xmlto/?C=M&O=D"
    regex(/href=.*?xmlto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae8265ff1eca0fe879c1ece963369b58abe515726f99b53832a5aded92b51e58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2947a0d38d964b133b1452fa8277d59b333980c549141b990f3f8cbfe9db5c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bec2a4a7797f07fc73a636a40e85cb0504da4c5e34328456c28e78c84ce95324"
    sha256 cellar: :any_skip_relocation, ventura:        "d90e8586c846dd0f299101e6ed940d0be828821d8e1c46cb1ca00b7febf83836"
    sha256 cellar: :any_skip_relocation, monterey:       "d86630edcfc8976b0a7a22f314b7a7062814fec16d52b90d8c1b4d850907222e"
    sha256 cellar: :any_skip_relocation, big_sur:        "95502b71000319da58971ea17c0dab0f326d20ce4c09d074fe4c7fe89c66d002"
    sha256 cellar: :any_skip_relocation, catalina:       "d2c21b9b398191e21dcf6e7ac53e4dd46fb59d29173e4d8443ac296101cce58f"
    sha256 cellar: :any_skip_relocation, mojave:         "8fca3be2271ae8e7fb646b011969ba4030f7421118a4ea6b11eca1ac0fe6979b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1214da1d14a8f01d8b8d0ead6606207ff5a29fb7ab104d6af47e57fbca4ffcc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd0f9ea84a854c7483a7eae5320c54baa3cb956e914044a522e3c3c041ab08eb"
  end

  depends_on "docbook"
  depends_on "docbook-xsl"
  # Doesn't strictly depend on GNU getopt, but macOS system getopt(1)
  # does not support longopts in the optstring, so use GNU getopt.
  depends_on "gnu-getopt"

  uses_from_macos "libxslt"

  # xmlto forces --nonet on xsltproc, which causes it to fail when
  # DTDs/entities aren't available locally.
  patch :DATA

  def install
    # GNU getopt is keg-only, so point configure to it
    ENV["GETOPT"] = Formula["gnu-getopt"].opt_bin/"getopt"
    # Prevent reference to Homebrew shim
    ENV["SED"] = "/usr/bin/sed"
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      <?xmlif if foo='bar'?>
      Passing test.
      <?xmlif fi?>
    EOS
    assert_equal "Passing test.", pipe_output("#{bin}/xmlif foo=bar", (testpath/"test").read).strip
  end
end

__END__
--- xmlto-0.0.25/xmlto.in.orig
+++ xmlto-0.0.25/xmlto.in
@@ -209,7 +209,7 @@
 export VERBOSE
 
 # Disable network entities
-XSLTOPTS="$XSLTOPTS --nonet"
+#XSLTOPTS="$XSLTOPTS --nonet"
 
 # The names parameter for the XSLT stylesheet
 XSLTPARAMS=""
