class Xmlto < Formula
  desc "Convert XML to another format (based on XSL or other tools)"
  homepage "https://codeberg.org/xmlto/xmlto"
  url "https://codeberg.org/xmlto/xmlto/archive/0.0.29.tar.gz"
  sha256 "ccf0657f71f874d01a28729e7c08ea468ae705e087a4e12d1dcacb6b54a5d25d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://codeberg.org/xmlto/xmlto.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "949ec7164297f748831a7ab87250d846fb30a105ad8baddce568b6b3ac7bff7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "093adabbf11aa710fcb01f202d87e16145258e602206c64b5aa2ab1f63f2014f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2411a7fc2154cbd347d2aaa8ab9e176d66fee18b727568baa3b8eeb65f71fd5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7f324ec83fa2423985776c484451b7b9b099c0432cdaceb8f72932a73cfeced6"
    sha256 cellar: :any_skip_relocation, sonoma:            "7c97020bc7310a85ddba7461e891c63de136637d26ec7cff04dca86ec13d1055"
    sha256 cellar: :any,                 arm64_linux:       "5bf1c1bb7849861745d92fb18d6c11987b305ca2714b67819922e2ebfe8a5ed9"
    sha256 cellar: :any,                 x86_64_linux:      "7225b4d8b7bcda34ae55ef034503ee7afe24a72d454a78870854a2bdc9a7ecc2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "docbook"
  depends_on "docbook-xsl"

  uses_from_macos "libxslt"

  on_macos do
    # Doesn't strictly depend on GNU getopt, but macOS system getopt(1)
    # does not support longopts in the optstring, so use GNU getopt.
    depends_on "gnu-getopt"
  end

  def install
    # GNU getopt is keg-only, so point configure to it
    ENV["GETOPT"] = formula_opt_bin("gnu-getopt")/"getopt" if OS.mac?
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.deparallelize
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
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
