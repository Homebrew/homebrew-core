class Stress < Formula
  desc "Tool to impose load on and stress test a computer system"
  homepage "https://web.archive.org/web/20190702093856/https://people.seas.harvard.edu/~apw/stress/"
  url "https://deb.debian.org/debian/pool/main/s/stress/stress_1.0.5.orig.tar.gz"
  sha256 "1798e49ca365d928fb194ba1b8e8d1e09963b49e9edb0a78bcbba15750bb5027"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/s/stress/"
    regex(/href=.*?stress[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d62a404e264f4d64f2e5a14c9adee3f6cdb3593c31880410d24f38accea32bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dc5c125c3eb8cf95cb21bf4ae2efaf114b9b47677747026ba92a5c9eb09ad6e"
    sha256 cellar: :any_skip_relocation, monterey:       "c3a4929d6031c9cdf21cb81c8b3ff06b3a9bad924194eeadba7996aabb9cd9a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "00d9ed736381a3967b8eaf0b709328ccb0263640fdc856fe5c2e8f2164ea705d"
    sha256 cellar: :any_skip_relocation, catalina:       "2fb692ddaa54337dfe07eb71ee647e167bbe41db054556c32d7507cba38caa43"
    sha256 cellar: :any_skip_relocation, mojave:         "6220e38d281aa1f7933c582711083d2e33bc36071e32776a55a6c8441e3de209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b303854895396f0b6b5a75e654b5315ae4eccd5d4c7de451d7d1997edb0a7e7a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"stress", "--cpu", "2", "--io", "1", "--vm", "1", "--vm-bytes", "128M", "--timeout", "1s", "--verbose"
  end
end
