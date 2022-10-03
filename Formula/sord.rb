class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.14.tar.xz"
  sha256 "220fd97d5fcb216e7b85db66f685bfdaad7dc58a50d1f96dfb2558dbc6c4731b"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "8eb7852e92c07a0568eb3b1078fe4b1c98a78967e132b349277778ce5a64e669"
    sha256 cellar: :any, arm64_big_sur:  "5ad330d521065a4e6a2b4ea108351b76a5f72bc93e826b5b075ffef9bbab0f1d"
    sha256 cellar: :any, monterey:       "ca0fee6b4bc2d71adeb56105059c37e3bf6095f1be32f1d76d8038a08e3e4b69"
    sha256 cellar: :any, big_sur:        "cea0a3af56dd4664a8da6ccc3c17baa9fa24ac7bf133974e74f5b4f1779d5151"
    sha256 cellar: :any, catalina:       "3ad280523cec50c8b78f5068370b4c30715ed2ac9701399ff97832779e2c6b5b"
    sha256               x86_64_linux:   "8e32112379fb85c693042658262a7c9777cb82765be95db2c5417605358457dc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "serd"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dtests=disabled", ".."
      system "ninja"
      system "ninja", "install"
    end
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
