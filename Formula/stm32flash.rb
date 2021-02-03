class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.5.tar.gz"
  sha256 "97aa9422ef02e82f7da9039329e21a437decf972cb3919ad817f70ac9a49e306"

  livecheck do
    url :stable
    regex(%r{url=.*?/stm32flash[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7372711f48071b5bed9d390c94e882dc3aba62219ed608ca824490b7e64e0d01"
    sha256 cellar: :any_skip_relocation, big_sur:       "87f174898ba1c72a3d3b5e71f197681af38ed2715b7f52a27336d0664686f347"
    sha256 cellar: :any_skip_relocation, catalina:      "ad0d22f81963099a648b32697bf1a14ca3ee51cd45f8e73f0f701d5836faecee"
    sha256 cellar: :any_skip_relocation, mojave:        "14bbc585e618bf4c223e0008503f9007ef3686e3472a1a1f2bfc8122af42793c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2cbbf094a7f2777b674909a5f846bba0cb613a5c2c38e980b67bd769b924e5f5"
    sha256 cellar: :any_skip_relocation, sierra:        "74a92cff8b8099a2b8ee8aa0a2a360639400eb53a24b625c149b052e3f26521e"
    sha256 cellar: :any_skip_relocation, el_capitan:    "1e49a9386e4aac0260e3b24872714e59f3984c7f6fb2779e9bd89e0d23bc1655"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/stm32flash -k /dev/tty.XYZ 2>&1", 1)
    assert_match "Failed to open port: /dev/tty.XYZ", output
  end
end
