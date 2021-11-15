class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "https://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "https://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?with-readline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d0fbb8e109734765f470ff267c0c45f3ae958615bc162f3e541b9e4f219d7ec9"
    sha256 cellar: :any, arm64_big_sur:  "7a8f7ff1d33453d059ac6ac6b23883fa3f86d720cb25415e590e81ca2e6255dd"
    sha256 cellar: :any, monterey:       "96e916f5b1f84b40c4aca915dce1731428e4fadf69269932098a8ffa87168554"
    sha256 cellar: :any, big_sur:        "0700f15130da53328bff304e2cfdb422ad2bc4fff64a0377063af94cf46d3655"
    sha256 cellar: :any, catalina:       "b0ba2ed66eff2c432234e5885ebeca2a671bb556024ad038563883b3c14a64b4"
    sha256 cellar: :any, mojave:         "3a6e8e8e2d6f35ecd215b969c3794e586b1209820a9b0e5d935ddc5363f58678"
    sha256 cellar: :any, high_sierra:    "72ea8c0cce2f94fae5c963a1113c9b2504f1d728234c3c511ad7e3d5dca0d74b"
    sha256 cellar: :any, sierra:         "808a3a96b1d247f16c0a3e21eb18ed287f7df474b36c4685725768a05c3c1c61"
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/with-readline /usr/bin/expect", "exit", 0)
  end
end
