class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/sid/tmpreaper"
  url "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.17.tar.gz"
  mirror "https://fossies.org/linux/misc/tmpreaper_1.6.17.tar.gz"
  sha256 "1ca94d156eb68160ec9b6ed8b97d70fbee996de21437f0cf7d0c3b46709fecbc"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/t/tmpreaper/"
    regex(/href=.*?tmpreaper[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f9987a8435e18ce63b2214cd6bedbb56902c09c8cf88614c0dfab73d418c003"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b17b5648f769f3c80d2d596deecd90a5af28bdd9b3317944f933bf7b469627a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3c26e98c4ec6ccd7d0f4d8724732009a657c6d147d3343bec352cd3e9fc6805"
    sha256 cellar: :any_skip_relocation, ventura:        "714d2ff483bc2027650c7fd229d3244fae4213e7d1a26a73e14e75f4fa1c61b2"
    sha256 cellar: :any_skip_relocation, monterey:       "ff0057f9690d3aa599b4a9d7c5fbeb9f40b1ac9034883609c15945d0e23fe9f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d01353b90faaf5008d624b4230578610b957db76447b48e03f67a53b8b5f7a11"
    sha256 cellar: :any_skip_relocation, catalina:       "f93c52bb2db3eab2e179e1184847d867a008300c7d00cee89f868e60a161eec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c41062bf046a8d1ca4d6cbb1a9ee38133d4e50d85d83ccac9afcd812139a164"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "e2fsprogs"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    touch "removed"
    sleep 3
    touch "not-removed"
    system "#{sbin}/tmpreaper", "2s", "."
    refute_predicate testpath/"removed", :exist?
    assert_predicate testpath/"not-removed", :exist?
  end
end
