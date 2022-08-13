class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-280.tar.bz2"
  sha256 "d62a967ab51e84b14f33add98c9618eb1a3da07a0d2bb9defdae8cdfee0be2ca"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a48c7648139899b3a4206ca33a137e1dc6aa950007e9574f835390d83e17fcf7"
    sha256 cellar: :any, arm64_big_sur:  "18ba3a85c4139936c362598592e8a21f269ef0ce874fc6730fd723e2542f5be8"
    sha256 cellar: :any, monterey:       "6edeecea280c203fa68ce8430b748c3985f728ad93b823674c1f7c2fabcb2be9"
    sha256 cellar: :any, big_sur:        "38d6ed9eeeae27c911a7082435b624e2f725ec3755211828ed5a1694e82cfab1"
    sha256 cellar: :any, catalina:       "166ac7a487e200f42cc6dc5752b6750c5e8e35458b5fdd2f8d996e6b8467e7f5"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
