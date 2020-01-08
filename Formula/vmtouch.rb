class Vmtouch < Formula
  desc "Portable file system cache diagnostics and control"
  homepage "https://hoytech.com/vmtouch/"
  url "https://github.com/hoytech/vmtouch/archive/v1.3.1.tar.gz"
  sha256 "d57b7b3ae1146c4516429ab7d6db6f2122401db814ddd9cdaad10980e9c8428c"
  head "https://github.com/hoytech/vmtouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30c620a4dc06285c41c7194468de50cf0f12aab38c6441d8e1bbad6d4231ee1e" => :catalina
    sha256 "020d4e624a448e4e1b9a6e26b8f506bd65ab789ae1c0f23f25beda78b09bc6dd" => :mojave
    sha256 "edb14ca1ff4cbd4ab535ca9099ea113a36e280ddaf2957a65bdef10f4a7a1b88" => :high_sierra
    sha256 "7359ed3256886940e6fb1883141c495d5b3e6ab28130ed16553e0f6ab57ac3db" => :sierra
  end

  # Upstream change broke macOS support in 1.3.1, patch submitted upstream and accepted.
  # Remove patch in next release.
  patch do
    url "https://github.com/hoytech/vmtouch/commit/75f04153601e552ef52f5e3d349eccd7e6670303.patch?full_index=1"
    sha256 "9cb455d86018ee8d30cb196e185ccc6fa34be0cdcfa287900931bcb87c858587"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"vmtouch", bin/"vmtouch"
  end
end
