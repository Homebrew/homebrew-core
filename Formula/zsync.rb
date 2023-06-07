class Zsync < Formula
  desc "File transfer program"
  homepage "http://zsync.moria.org.uk/"
  url "http://zsync.moria.org.uk/download/zsync-0.6.2.tar.bz2"
  sha256 "0b9d53433387aa4f04634a6c63a5efa8203070f2298af72a705f9be3dda65af2"

  livecheck do
    url "http://zsync.moria.org.uk/downloads"
    regex(/href=.*?zsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c26ab39f23b57f14fcb5407541cc6785209d09c4408d516069d8fe8694f5e01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d9c561ebe0167e590847ed7993ff01e098eed20ba1ab158ffc3fc6a1295d220"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ee85fb722fa125e4323e14732d4de448f3751e9445e2ec6933fce0ee38d5a90"
    sha256 cellar: :any_skip_relocation, ventura:        "aa55a9ccdc3c06c605580b6820afd107819cf970a59f96beed53e7988f73e8fc"
    sha256 cellar: :any_skip_relocation, monterey:       "257f153c9f34b33cfcbcb08aeaab17a7bdf5c5a0538edf96c1a9a6f8074dd212"
    sha256 cellar: :any_skip_relocation, big_sur:        "1be9e390c02555dbce349a76e0beb63231bc327f4326580b18679ff0307db446"
    sha256 cellar: :any_skip_relocation, catalina:       "333d4b2be5c1b6621bf7e7ac87199da1c5ec24a3cdb408c97ed733b6fafb89a1"
    sha256 cellar: :any_skip_relocation, mojave:         "9fa9f958c45a87c1a4e9b2ccdc95e732bb8ab248843ec3f0554e5b412d7f1ae5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b766bfc58f753376213e234d8e0e4238af1be39f77f239370583464040758fd6"
    sha256 cellar: :any_skip_relocation, sierra:         "8d6e7eade289c62689e752151021e7bccac7900a5e7217e8885f2c38aec42c2c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "9bbe0e102ca6a2b7ca57af6b2b29984f7da59ce97d15ce550bbbb206f1ad1815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1961843c2195ae143b2f2ece7e26f91aa4c5a0acc67721441c221b5ae3404150"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "#{testpath}/foo"
    system "#{bin}/zsyncmake", "foo"
    sha1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    File.read("#{testpath}/foo.zsync") =~ /^SHA-1: #{sha1}$/
  end
end
