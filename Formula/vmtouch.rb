class Vmtouch < Formula
  desc "Portable file system cache diagnostics and control"
  homepage "https://hoytech.com/vmtouch/"
  url "https://github.com/hoytech/vmtouch/archive/v1.3.1.tar.gz"
  sha256 "d57b7b3ae1146c4516429ab7d6db6f2122401db814ddd9cdaad10980e9c8428c"
  head "https://github.com/hoytech/vmtouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "854bd4ab9a30fbb09adea336b29660bae8cb1b56811d4023822008172736b7de" => :mojave
    sha256 "94cbb48095dbd350e29591f055d01789df27991deda9419d42138641e7386274" => :high_sierra
    sha256 "036d04749746169bd38c71e8637b235edd6ac8b1cc007a884e094a3004ce1933" => :sierra
    sha256 "fa1dd70ebdef2556d84315c28c693f5de9f18ee4b545205a030d1216af58a34a" => :el_capitan
    sha256 "e1e4bd20e994a155ea892305cf6c87aac9206bea4a94b2a59439e836ce15a10a" => :yosemite
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
