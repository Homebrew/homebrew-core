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
    sha256 cellar: :any, arm64_ventura:  "20489ceee76a03468222d1664ab094b742974816d2dfee437eab8c12009a16c4"
    sha256 cellar: :any, arm64_monterey: "96032d07b0ac3f7364b721c935a215c6f792abbf79a8ad6004638794ae65a4d5"
    sha256 cellar: :any, arm64_big_sur:  "b7ceac3c480159338053a7dd2da2ecab47bf61c238332a10f8700470101cc226"
    sha256 cellar: :any, ventura:        "2dcbcfef5db2ad4ab4e44addeda16ba5490d9e773015e8137c7005956dd40c28"
    sha256 cellar: :any, monterey:       "5181253c794efcb69212b0b22573cadd5d2d92161c1b6a725a74c40dcd718f6f"
    sha256 cellar: :any, big_sur:        "b2f8da7c926a2280fcd124bf494a7307c5a655cd3d266791b03b34556839fda8"
    sha256 cellar: :any, catalina:       "faf8da2bf68426cb85aafdc8f3caaf2cbb246c2d8369b7c390b803e53b209331"
    sha256               x86_64_linux:   "b1f84037affacbb7878f87d88c10944681091bc4633f24170e7869ac72aa0182"
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
