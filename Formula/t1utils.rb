class T1utils < Formula
  desc "Command-line tools for dealing with Type 1 fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/t1utils-1.42.tar.gz"
  sha256 "61877935b1987044ddff4bb90a05200ca7164678a355e170bf5f1a5556cc9f29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4d23288e682bb4e3b023a9d18add81d799fa6d0c80c651c69a7497b82411605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee7b36a362724bfbcfe108b289536233ebdef429b53e03066db92b1ae2c26d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5880dea5e9c08afe66db47718f279d36e636ed47def53f45aa7d7bb9aec6326"
    sha256 cellar: :any_skip_relocation, ventura:        "0745253b0e4c533a823d4f550523ce3eb714df032cd3734f865da685bb5fa562"
    sha256 cellar: :any_skip_relocation, monterey:       "af52f609acbfc2496ef0592b5d42e8e61bb074289592334049bc59995a7551b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f00f838c4ebef97926c3a2cd9940d2105029839a25543f9861903ec1a71939e1"
    sha256 cellar: :any_skip_relocation, catalina:       "dfaaef0c838273e5c4cee7d6d2eb515e91c77c3226913b4c4486ca0086c2e6bc"
    sha256 cellar: :any_skip_relocation, mojave:         "1b511df389dee041c0cdadae94e38e987ea978024730d687b8642623cb054e09"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c17de51c95690f3133933cd508873e21734a8e4f8ed80ec6546ab3c7fb82edd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc65100916f687ae2019390d262a22eb6bfa2e203bb3f125be5d7d10469764e4"
  end

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
