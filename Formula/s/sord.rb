class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.18.tar.xz"
  sha256 "4f398b635894491a4774b1498959805a08e11734c324f13d572dea695b13d3b3"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9482cf28bd5e2d77ed057903e53157a57e09355e8a6c69eb935fdefc67c79505"
    sha256 cellar: :any, arm64_sonoma:  "bd8611d53bf08d025037edaa7ef83e635dbe853c3783ed94909a1edfc93d7457"
    sha256 cellar: :any, arm64_ventura: "41fcd2ff39ea5a50392a5a3b31c523ca5c7e087e1d0124c1b8101da518e40bf8"
    sha256 cellar: :any, sonoma:        "d1230019e29331722881ff6ecaa0533dd452b350792394a7c8f701f8ffde46dc"
    sha256 cellar: :any, ventura:       "70e0cf3dced39cd9b5b0a069a0261fed4e758412f625e4803449d27e6fa07f72"
    sha256               arm64_linux:   "cb55e96bc9ead5b118ced1ace42f11a2641e7475c6db29e24facfe9bbb743146"
    sha256               x86_64_linux:  "eee6fa6352554b778e2a51f04791a165d4bf3ca78379ff205481ae157bb2dc35"
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
    assert_equal output, shell_output(bin/"sordi input.ttl")
  end
end
