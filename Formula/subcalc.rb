#
# Formula for the subcalc tool
#
class Subcalc < Formula
  desc "Subnet calculation and discovery tool"
  homepage "https://github.com/csjayp/subcalc"
  url "https://github.com/csjayp/subcalc/archive/v1.2.tar.gz"
  sha256 "7bc926b22aa75749e1ab5878932887bc1811115703aac646c04c55f39b2809a8"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/subcalc", "inet", "127.0.0.1/24"
  end
end
