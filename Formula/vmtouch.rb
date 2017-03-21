class Vmtouch < Formula
  desc "Portable file system cache diagnostics and control"
  homepage "https://hoytech.com/vmtouch/"
  url "https://github.com/hoytech/vmtouch/archive/v1.3.0.tar.gz"
  sha256 "4615980b8f824c8eb164e50ec0880bcb71591f4e3989a6075e5a3e2efd122ceb"
  head "https://github.com/hoytech/vmtouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "036d04749746169bd38c71e8637b235edd6ac8b1cc007a884e094a3004ce1933" => :sierra
    sha256 "fa1dd70ebdef2556d84315c28c693f5de9f18ee4b545205a030d1216af58a34a" => :el_capitan
    sha256 "e1e4bd20e994a155ea892305cf6c87aac9206bea4a94b2a59439e836ce15a10a" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"vmtouch", bin/"vmtouch"
  end
end
