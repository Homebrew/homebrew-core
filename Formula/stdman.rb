class Stdman < Formula
  desc "Formatted C++11/14/17 stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2017.04.02.tar.gz"
  sha256 "64f33e843c646de54745f234df7688df400a6f65f738408406cb48bcae2c852d"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e331f279e0e88fc136531b0a0bdece2dfee271c6ab96f2047e51a34651f37ac1" => :sierra
    sha256 "8f40d671b1f63facc15c957ddb6eb1a58332bf13e68eef888175948017e79386" => :el_capitan
    sha256 "2b137b92e15bf5941697df2f6fab98a8e030024bbbb0ddc5864f2bbb076f6223" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "man", "-w", "std::string"
  end
end
