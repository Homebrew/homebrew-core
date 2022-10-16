class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-283.tar.bz2"
  sha256 "d939f0c47022896132b47a4a5eb13043e6a3ab5f5fd25bfbb2cf38da490fb386"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4720fe240d1defcb28fdbc34bba45f3687376038a68962525a5116e4eaf83fc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a570276df9564a19729082951a3831a5119025a5daad6aadb0ddbf6ebdded3c"
    sha256 cellar: :any_skip_relocation, monterey:       "ea0c6c9b547030cce22abdca4f5509bfcb1677a96a1f19bc4debb3f638b73e83"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfe3985bff5ac02b3f90f387f54e937aa4bf2ba1785c98ff93ef632f393f3427"
    sha256 cellar: :any_skip_relocation, catalina:       "134b6bacdb48a5c94ff02fdee577af71edf3fca9ef2ac8186fce1ac5a615a03b"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end
