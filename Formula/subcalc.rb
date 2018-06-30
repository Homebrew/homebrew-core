#
# Formula for the subcalc tool
#
class Subcalc < Formula
  desc "subnet calculation and discovery tool"
  homepage ""
  url "https://github.com/csjayp/subcalc/archive/v1.0.tar.gz"
  sha256 "8a9e86f9dc85cb4c59d0d85483e0a0a5affca84ad93c90de467ad5974ada5e7a"

  def install
    system "make"
    bin.install "subcalc"
  end

  test do
    system "#{bin}/subcalc", "inet", "127.0.0.1/24"
  end
end
