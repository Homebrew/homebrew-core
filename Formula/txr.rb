class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-254.tar.bz2"
  sha256 "981e6f0ac4ac4c9c6157be5899c1af3751a20b4ceed81c95f61beece82d87f7e"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "5c5265218df337e9d4351615a26b58142115ae837c452e590f2e945d0a1e40e1"
    sha256 cellar: :any, catalina: "6ba6d23b92599eb10825b0a97f8dd82a8f61c7443c2ce45d75194713259b4c12"
    sha256 cellar: :any, mojave:   "dfdc8bca913cb1ca475141734139552723b408de1f840a9592f7350f2c5851a2"
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
