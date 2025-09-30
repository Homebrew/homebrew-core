class Xmlto < Formula
  desc "Convert XML to another format (based on XSL or other tools)"
  homepage "https://pagure.io/xmlto/"
  url "https://pagure.io/xmlto/archive/0.0.29/xmlto-0.0.29.tar.gz"
  sha256 "40504db68718385a4eaa9154a28f59e51e59d006d1aa14f5bc9d6fded1d6017a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pagure.io/xmlto.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "91da6f2fe6817daf5c455fe6c5c63b01188c71d017d16b37dbb49ee5bf4355d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a131d56e2e03b70f96c405262bf31ab9944de622d799b7341c1fe9b07ea0e34a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aeeb037d079947e51c9e743fd1c87dcf4eaa6db340afeceb880fa1e91fe86129"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a3a8cc72243b732191e706c96bf4e9a827300d529a3226f6a4ca26ee5fef5ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "479938c37c2f5bda455b31dddc2a587f464b731cc887a698f0a90f89de3cd6ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "94b2d369c743d833b9e4fa2f6658c47f4a85fa8c94202ddcd6db88244f27e7d4"
    sha256 cellar: :any_skip_relocation, ventura:        "fbcc16655585b93b6c3598bd2e712551f88e48bc6062f045914e7f22b4c6bf38"
    sha256 cellar: :any_skip_relocation, monterey:       "6c44cf87fbed1ee9587e74be7fa06d5a8cc392509a05d9f6a37f69d99e765822"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f699cf8ced80aa5aa63079d7f44b35a12445b5df94923ba64843596832ca8757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350a0d789e034e3717a5e03ce2110787ded5b6b9a4582b38152c670b10909e0e"
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
    ENV["GETOPT"] = Formula["gnu-getopt"].opt_bin/"getopt" if OS.mac?
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
