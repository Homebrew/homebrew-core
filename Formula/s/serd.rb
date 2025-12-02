class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.32.6.tar.xz"
  sha256 "0fbe094952fe176ba4da4f2f767ddfb5f60e67e64d1761b4383a0b872cfd071a"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09d164a879d314a61d5a50ede56dadd89b800dee33ea85af51794e3f12748a69"
    sha256 cellar: :any,                 arm64_sequoia: "98c1d121322f398d69e50894c77e4907720e8c31527432b58821f9825d764eb7"
    sha256 cellar: :any,                 arm64_sonoma:  "b36df8e5f6a223e7171541db24420046f824e9edda482275bdd58da92b9becbe"
    sha256 cellar: :any,                 sonoma:        "607e512acafff9dedd17cf60cd32f7a89bf5f357cd2f4e2a8ed5485b3fee0267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2635aeba254c70bc7ab10b1d1cfedcc38dc054667589187d8cb144dd7dee8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28b69e6551bf7a832445b6ccb6735db127790e6ad3e28aee5b5f1e2a0e7c067"
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
