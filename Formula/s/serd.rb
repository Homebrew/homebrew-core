class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.32.2.tar.xz"
  sha256 "df7dc2c96f2ba1decfd756e458e061ded7d8158d255554e7693483ac0963c56b"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6da3bc12299d08bdd94b31b39eb398895133440589a08307fd59f27a41f1deb8"
    sha256 cellar: :any,                 arm64_sonoma:   "64998f0f202c9dc4d9db24962d225b8575691230c9529e9caf5f51ea1cfe6a51"
    sha256 cellar: :any,                 arm64_ventura:  "a90f4099dc15980f2d3434153cbb09b5cb4da1e359514f0ec5b7503fa3236d0f"
    sha256 cellar: :any,                 arm64_monterey: "1b92544391c0b1a50707d923824e5d6762ce7348b4078d108d122a950854f782"
    sha256 cellar: :any,                 sonoma:         "fc6f974050534d696af8dadbe2540b184cca110684125c5d16b7b8757b414389"
    sha256 cellar: :any,                 ventura:        "07c535671ae8df56222c86f3033dcac69f998195f048d32c36d3c030bfd7c7b3"
    sha256 cellar: :any,                 monterey:       "c94b0036ca6c651de4fc692640b055ec09149c13eebcb3ab321f2cf06a86c05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af54bbd35eed60339757f56f0a603f4d27ba1b44b8c7b60d18bf8b67438eaa21"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    rdf_syntax_ns = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
    re = %r{(<#{Regexp.quote(rdf_syntax_ns)}#.*>\s+)?<http://example.org/List>\s+\.}
    assert_match re, pipe_output("#{bin}/serdi -", "() a <http://example.org/List> .")
  end
end
