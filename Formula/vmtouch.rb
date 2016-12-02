class Vmtouch < Formula
  desc "Portable file system cache diagnostics and control"
  homepage "https://hoytech.com/vmtouch/"
  url "https://github.com/hoytech/vmtouch/archive/v1.2.0.tar.gz"
  sha256 "154034dec5ef550dcb7ff5a359ee1b7a9421f586f47237e3bc2617efa148b5fd"
  head "https://github.com/hoytech/vmtouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba9345723812a60b3e78d7d60b303d11ad2d7225e92654e702ecad6fa80d93ec" => :sierra
    sha256 "7c73faba33612e335fe6ccf32a8b913fe7ce5ada7c56017b578c2c629aef355b" => :el_capitan
    sha256 "aa548bc9c6dca0bd023bc08b63dd5f83cfb1d89e2573b9d84c8173a1fec02be7" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"vmtouch", bin/"vmtouch"
  end
end
