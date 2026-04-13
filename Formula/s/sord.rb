class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.22.tar.xz"
  sha256 "bb23b34b216579136795d518cffa73d91cf205594ce9accebfd408afb839173f"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d601b06900746e2c9cd81dc91701ceb1bae9400e04b24bc1ba0d7006970eaad"
    sha256 cellar: :any, arm64_sequoia: "b5d34d39cee51b1ea2da94aa693aebc8b5413f109f20dd31469bc8f3d9da96ae"
    sha256 cellar: :any, arm64_sonoma:  "5a6e268d98524a5a65f754ed4382931114224c6e36d2454381cb15025a7f77c3"
    sha256 cellar: :any, sonoma:        "ff7a7bc3b353a1dfe56144056aba13239bfda5a1158797cd90648db36a8a4e52"
    sha256               arm64_linux:   "f806b8548ac19ca37c21be5c746ba5619cb02b5369eefa5cbe5b4c5f0a034581"
    sha256               x86_64_linux:  "97a9b803c95513489075f33ec9575553ad37960e74db859606fcef1f48a0662a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    assert_equal output, shell_output("#{bin}/sordi input.ttl")
  end
end
