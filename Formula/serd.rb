class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.30.16.tar.xz"
  sha256 "f50f486da519cdd8d03b20c9e42414e459133f5a244411d8e63caef8d9ac9146"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "88449226b9a9b18d4b59cf0365af5722a3600eee09efd545d0c7742cc116b668"
    sha256 cellar: :any,                 arm64_big_sur:  "b48484ddbc698e3df53e2e673e74092a749ec5b620e38ca87cf029d555a2c35f"
    sha256 cellar: :any,                 monterey:       "69212a51830c1a236502f5b5e1a600399b411f6be1b96b2b32ac1f75574b59be"
    sha256 cellar: :any,                 big_sur:        "502abedf5cca58588ba7241d7e26d1acd3c2896b39b5fa3ff8bfdf3e28780d65"
    sha256 cellar: :any,                 catalina:       "fec7b444a66a2065eeea33f6d5f76bdde71f25e123cd56ed94a4df8cc04d10a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f03736f95ad66e9f7350136dc14bc49db8b73e61a9457ee3bf38780e3d84583"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    rdf_syntax_ns = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
    re = %r{(<#{Regexp.quote(rdf_syntax_ns)}#.*>\s+)?<http://example.org/List>\s+\.}
    assert_match re, pipe_output("serdi -", "() a <http://example.org/List> .")
  end
end
