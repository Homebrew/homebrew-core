class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.32.10.tar.xz"
  sha256 "b0e93b49e52f01a049475b7886ef140407115a32d3b1e5dc5f95141c88275d1c"
  license "ISC"
  compatibility_version 1

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d39be0f8c1498ccd0c59cd20ce515c65e21c38552407261dbd39f690224b0b43"
    sha256 cellar: :any, arm64_sequoia: "e5ec3d695060a86f1296d2a486231c905b2946ba9778e359294da8d76f3db2b2"
    sha256 cellar: :any, arm64_sonoma:  "652ac2982bc628fc3981b92958185da3498f8928dfab5760ca0bb7e6600ad516"
    sha256 cellar: :any, sonoma:        "800e3c2a4fbe5caab080c8a25604526ef0d142b5410efb49b7920cfccbbb8afd"
    sha256 cellar: :any, arm64_linux:   "56d6fbdeb73a5c41804d4f634571613de9399dda050dba1e895e5b8c0edc6823"
    sha256 cellar: :any, x86_64_linux:  "09ad9868e32d76f4c1e6e3eea969b62d95952ab91b7faea824787b541119c58b"
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
