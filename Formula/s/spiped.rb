class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.2.tgz"
  sha256 "05d4687d12d11d7f9888d43f3d80c541b7721c987038d085f71c91bb06204567"

  livecheck do
    url :homepage
    regex(/href=.*?spiped[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "fb49b420bd935b728f767276c0bb19133d745d52fe07a8ebad3877ff09996dfc"
    sha256 cellar: :any,                 arm64_monterey: "293b53d8433d104f8133539224e412209605bc40d2cacaeb253081b95eb65578"
    sha256 cellar: :any,                 arm64_big_sur:  "f30a91f2902faec487f48d0e580a34cc628c6cf4d80bab749ec32e0f38c575f4"
    sha256 cellar: :any,                 ventura:        "f655204362f17020c0672a494144c32a8351ff5281e49238b0341c26da065e15"
    sha256 cellar: :any,                 monterey:       "86fc3f6a8ad438e67a726d6e181774aa7af39b664345d6c5d0efbacb1267f86c"
    sha256 cellar: :any,                 big_sur:        "f22668dad3e0af145761bf04d604c12d05a9ac397449e6bcf3b33cb29bf41849"
    sha256 cellar: :any,                 catalina:       "a5a8967be00fba49a628f6d18cfe2ec69f40ffdb3d860eed91bd3026225d5c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce1ab53824d6e9ccd9752ab5038630ab179f73053ef8fa941c894e38ecab171f"
  end

  depends_on "openssl@3"

  on_macos do
    depends_on "bsdmake" => :build
  end

  def install
    man1.mkpath
    make = OS.mac? ? "bsdmake" : "make"
    system make, "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
