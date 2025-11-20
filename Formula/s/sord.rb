class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.20.tar.xz"
  sha256 "508b41d6b4f9d5902c9f5b9cf25170d9d0636f68f11bd257c1150497f754a2a4"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ab006a59a89f0b0db4ce87eff3fc0911baaf491f44b6b6463e78a4fea514d2be"
    sha256 cellar: :any, arm64_sequoia: "d56c550ae6beb8b69c3f20f5224c4cb16fa7429116d3dcb3c8cb673ee1c419f8"
    sha256 cellar: :any, arm64_sonoma:  "10bce645b80a0faa83611e46db06ab1163b6ba6316f138d76c1d1089e79aabbb"
    sha256 cellar: :any, sonoma:        "d7818695f1a1b4ccadac0c3d72422980c033975769f5a8d86373a732dc1baf81"
    sha256               arm64_linux:   "21fc77d71407c56f348990841149c60e98eff9972af4526a10ed2e54e5a21ae2"
    sha256               x86_64_linux:  "8fc56998b0a134ef0026e8936dd5b27b979a4b62594441969266647f054956b4"
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
