class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.32.8.tar.xz"
  sha256 "f47259bc38ba553b0deb8b6dab6b5b73d3630469a7c9439ccdca80e06d7c1ece"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f371b9f3301f85f75822da77e75eea6524db3c0305bf943720050cffd1b5ee30"
    sha256 cellar: :any,                 arm64_sequoia: "7008c0d17aac090e639f7367a85d900f9830fe3dcb88dc7e84065c0ee1e13abd"
    sha256 cellar: :any,                 arm64_sonoma:  "e1ccb5898f2e0a5810d248f628c7e314aaab82f5f0b1f1f1c97cb58ecef04eba"
    sha256 cellar: :any,                 sonoma:        "fd4e6896bf64f85e2242168edabb9c31de0c96bd5d3c12183365cbd0a4e056ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47e7496192f30328f66c33d63e45bf640ad381cda5eb19a413ee5569db15bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc7fc642d67f803be7a658dfecc7fa23b1c067b0e2ccec339de9933348bd5580"
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
