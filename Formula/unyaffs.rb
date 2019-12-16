class Unyaffs < Formula
  desc "Extract files from a YAFFS2 filesystem image"
  homepage "https://git.bernhard-ehlers.de/ehlers/unyaffs/"
  url "https://git.bernhard-ehlers.de/ehlers/unyaffs/archive/0.9.7.tar.gz"
  sha256 "17489fb07051d228ede6ed35c9138e25f81085492804104a8f52c51a1bd6750d"
  head "https://git.bernhard-ehlers.de/ehlers/unyaffs.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ae6292113c0b5103b71e25c0bf935d2f526ae76b276c0b09fbee62071a2fd8ee" => :catalina
    sha256 "93a015d1f905f0a90a6238ca3131fb20a97e9d51ffc588a28fc3a11f53a3396e" => :mojave
    sha256 "ef326db142d70f8292a035cc015bdab8b6c777764451f359515b78b5fd4f0735" => :high_sierra
  end

  def install
    system "make"
    bin.install "unyaffs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unyaffs -V")
  end
end
