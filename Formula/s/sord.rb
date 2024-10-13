class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.16.tar.xz"
  sha256 "257f876d756143da02ee84c9260af93559d6249dd87f317e70ab5fffcc975fd0"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia:  "9534a78d2099f3cc7938d5c25b23e17d270e977dafd203bd3c5e3d5f292ee915"
    sha256 cellar: :any, arm64_sonoma:   "ccb2cea1a9eb0a3872148c76b00d4010c871b5c6d08b33a7cf558f44abbccdf6"
    sha256 cellar: :any, arm64_ventura:  "1f98b5a02176c345ebdfdde01c85ec692674f6e1915f7c78ed4121ff0d593bf3"
    sha256 cellar: :any, arm64_monterey: "0c86de68f0c8c679798fb812879a10bf1186c08df7d811f31b6ecaa36fbc42fc"
    sha256 cellar: :any, sonoma:         "4da2463d79cd7dcbd974b6b241d502c11e4e3b98bbd3d99d44bc40ba81021c8d"
    sha256 cellar: :any, ventura:        "68a1b2a740872fd9c03d81531507bc9cbfcc1eba056c6b54db6026767fc6b6a0"
    sha256 cellar: :any, monterey:       "a3ea28a4fd497a0b142a2c115a4b0eccfee2735740a98f1b6a1c7e0fe9f5f55a"
    sha256               x86_64_linux:   "56d3b1402f22c80f6c11ce31151a40bf136f2f1c6dd3b42a7db303206cea91d8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre2"
  depends_on "serd"
  depends_on "zix"

  def install
    system "meson", "setup", "build", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    path = testpath/"input.ttl"
    path.write <<~EOS
      @prefix : <http://example.org/base#> .
      :a :b :c .
    EOS

    output = "<http://example.org/base#a> <http://example.org/base#b> <http://example.org/base#c> .\n"
    assert_equal output, shell_output(bin/"sordi input.ttl")
  end
end
