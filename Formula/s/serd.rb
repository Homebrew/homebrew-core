class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.32.4.tar.xz"
  sha256 "cbefb569e8db686be8c69cb3866a9538c7cb055e8f24217dd6a4471effa7d349"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb7d131a4e36b9af03afd71b9a52977b7f8c03855cf59fe2c1425a82d266efa9"
    sha256 cellar: :any,                 arm64_sonoma:  "bd0c2273b21fd4823f8ae84a0b927af0e9d20d93f221e8eba269ac2a5f19490d"
    sha256 cellar: :any,                 arm64_ventura: "42b9a161e5f2b1b4a28183d16ecd0bff483519b292aeb982792f74201c2ff41f"
    sha256 cellar: :any,                 sonoma:        "a645922619955963c2d58856a30d91cbb0a74e63afd97027127a6c1ec684d7ed"
    sha256 cellar: :any,                 ventura:       "1206b5fd96a17388d8fa194ba4a1a5c9c59b9e2cefbf9bffa674bf8f71fd874f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a9563320d822db1023d6054f54cfc18c3a4a89266d4bb5a283c75159f05b3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52f9da3eed3f941a1c97f3a35764afcc8a5974b19a6ebf0952c28c8b239c6d3e"
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
