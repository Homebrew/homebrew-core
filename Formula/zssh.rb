class Zssh < Formula
  desc "Interactive file transfers over SSH"
  homepage "https://zssh.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/zssh/zssh/1.5/zssh-1.5c.tgz"
  sha256 "a2e840f82590690d27ea1ea1141af509ee34681fede897e58ae8d354701ce71b"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/zssh[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4450134a2610b41d037efaf910d6ccdf2cc6d836887b877337f91bf73d49f44c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b567d08589f3ba595994ca4906bfde9fe2651ef246bbd872f332e9cc8993a60"
    sha256 cellar: :any_skip_relocation, monterey:       "9387acd7dec913faa9917b3d27baaff250a412ecd509eba625543d188c6922a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "54bb3ff51405eda0900361c829fad63f988c21e685645fe5c8076c456567bd0b"
    sha256 cellar: :any_skip_relocation, catalina:       "6b9bce24c13dd2e979cdae57892e1b595bfcbd1d342bb81419dda378b8439495"
    sha256 cellar: :any_skip_relocation, mojave:         "0b1567c1d4aef681ff463f058a884eead039fb0c50a1c03820a03c9f67786b52"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9cb26f1bd359977406fae945abd311b2cdc5770570e6350f2ac278bfbe458f5b"
    sha256 cellar: :any_skip_relocation, sierra:         "49e01bb86097999f21f3d96b0f9cd63a975d4fd52f6e286d42ceee16ee996eb7"
    sha256 cellar: :any_skip_relocation, el_capitan:     "04212f19c1d9a6b97fd56ffe937606f1779849fdf04b93e3f285889599845c8f"
    sha256 cellar: :any_skip_relocation, yosemite:       "94280569f9e1c1deb9d8c3be4256cd501399fd51758f8e2ea6d77fd9f1b6ef2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb3265fd04dd6210c8706f04435d145e0941a50793aaccf7e1660b2956c1872c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "lrzsz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "readline"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    bin.install "zssh", "ztelnet"
    man1.install "zssh.1", "ztelnet.1"
  end

  test do
    require "pty"
    PTY.spawn "#{bin}/zssh -V"
  end
end
