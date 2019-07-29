class Xmlto < Formula
  desc "Convert XML to another format (based on XSL or other tools)"
  homepage "https://pagure.io/xmlto/"
  url "https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2"
  sha256 "1130df3a7957eb9f6f0d29e4aa1c75732a7dfb6d639be013859b5c7ec5421276"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "95e53e70ba98917fc455d3e602d7e610f9d3df41564714eef77eb9c7ad858972" => :mojave
    sha256 "924329e251704206fb5fecafbe78d0445e014d401f5184ea3b5f2f9c6ae8adc6" => :high_sierra
    sha256 "e6c35d8216b36e13a890d839296f51989d58fbf6e35666ee161dcae6f1e5fcd3" => :sierra
    sha256 "7b12ea43ff42eb5acdf91a1b2390af62cb95abd80e0a651581653c3d2b470b60" => :el_capitan
    sha256 "b0042227a7b6f00c5e4f7eb0e9b0ce6959ff401035d0914a8be60d685929c4a4" => :yosemite
  end

  depends_on "docbook"
  depends_on "docbook-xsl"
  # Doesn't strictly depend on GNU getopt, but macOS system getopt(1)
  # does not support longopts in the optstring, so use GNU getopt.
  depends_on "gnu-getopt"

  # xmlto forces --nonet on xsltproc, which causes it to fail when
  # DTDs/entities aren't available locally.
  patch :DATA

  def install
    # GNU getopt is keg-only, so point configure to it
    ENV["GETOPT"] = Formula["gnu-getopt"].opt_bin/"getopt"
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
    assert_equal "Passing test.", shell_output("cat test | #{bin}/xmlif foo=bar").strip
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
