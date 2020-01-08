class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.5.tar.gz"
  sha256 "97aa9422ef02e82f7da9039329e21a437decf972cb3919ad817f70ac9a49e306"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad0d22f81963099a648b32697bf1a14ca3ee51cd45f8e73f0f701d5836faecee" => :catalina
    sha256 "14bbc585e618bf4c223e0008503f9007ef3686e3472a1a1f2bfc8122af42793c" => :mojave
    sha256 "2cbbf094a7f2777b674909a5f846bba0cb613a5c2c38e980b67bd769b924e5f5" => :high_sierra
    sha256 "74a92cff8b8099a2b8ee8aa0a2a360639400eb53a24b625c149b052e3f26521e" => :sierra
    sha256 "1e49a9386e4aac0260e3b24872714e59f3984c7f6fb2779e9bd89e0d23bc1655" => :el_capitan
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/stm32flash -k /dev/tty.XYZ 2>&1", 1)
    assert_match "Failed to open port: /dev/tty.XYZ", output
  end
end
