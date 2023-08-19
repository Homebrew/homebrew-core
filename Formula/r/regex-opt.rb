class RegexOpt < Formula
  desc "Perl-compatible regular expression optimizer"
  homepage "https://bisqwit.iki.fi/source/regexopt.html"
  url "https://bisqwit.iki.fi/src/arch/regex-opt-1.2.4.tar.gz"
  sha256 "128c8ba9570b1fd8a6a660233de2f5a4022740bc5ee300300709c3894413883f"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?regex-opt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d4874247088ba62cdcf1304c0dfd6910812b0a6e6a915a3d160dd43f0e3202e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ce44869b68dab6e2d6bc5480c8c998b39aab0fc8dd56c915d9c8386fdea9778"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d8b19c7d0c896626944d9affc850e42f0073ecbfe82b6380f0ed494c13bc759"
    sha256 cellar: :any_skip_relocation, ventura:        "086aadac89bc6873dea864407ea634b84bc2b092ae6625a28ccb731ca9ac8fe0"
    sha256 cellar: :any_skip_relocation, monterey:       "1e232a280f15762a4de83d47a3bce3ae4ac726e9ad6ef8627ab47c425465b81d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c06ca3033c1a2d174368b4ca2194f732411c24911945cbad73b47a50ed1393b"
    sha256 cellar: :any_skip_relocation, catalina:       "8a561d7a4dfadf25fd39bd5b19d6a8161a2f0d1be2c459cbe691be17aef85bc0"
    sha256 cellar: :any_skip_relocation, mojave:         "76b26dc9e766e7a8b0806660e966e3a49c593591b94d90439f89b7cbc797d019"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0e46dec5d46b145e32ca597c00c75fea2e7097e57c5d3131be141e5bea2b96db"
    sha256 cellar: :any_skip_relocation, sierra:         "68b5f75c9fdb645334ae8a48a5b7e01620e19d5f103811579cb8bf96101c6ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf554c9bf9c98356aef52dc0d2eeeb514020d2505ed41764458f937e662b95e"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "regex-opt"
  end

  test do
    output = shell_output("#{bin}/regex-opt foo...*..*bar")
    assert_equal "foo.{3,}bar", output
  end
end
