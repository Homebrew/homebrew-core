class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-256.tar.bz2"
  sha256 "58e3e19bb7f3f9a440761f046fdacbc4d619b11c494a4ed9f8ad25c7a2974ddc"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "37ccb0ea715daa14f0f3d9836befa63b5403e380b3e0c8a2db14f7f2ff571380"
    sha256 cellar: :any, big_sur:       "d4613588dea96abc2fd8bdf9c2425ca0eb7a1c43280f8e5a478541f5eef2e01b"
    sha256 cellar: :any, catalina:      "dc488c6e97823ef1ab8a5de0773c07d171d9aa65104c91cc993ab68f10cb7e93"
    sha256 cellar: :any, mojave:        "2b3d4270e07e2e3654603ad5d7d07f23a88cfb169ec6290f083931dc82958800"
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
