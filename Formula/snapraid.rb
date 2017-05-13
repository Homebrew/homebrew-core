class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.1/snapraid-11.1.tar.gz"
  sha256 "b9acafeb6cece61fd426f08362b596ba89eea0564231955b82156fd09c0e6884"

  bottle do
    sha256 "ee0f9a795f2fa1af515eee0733f7e9d20e10fe2971057264d54f748faebbb845" => :sierra
    sha256 "ccff98a96d5136cbe1e8e64f50190100e909fa194ff623b4adf7e18b3dc201fd" => :el_capitan
    sha256 "fcf97bda192b15c62638304046aef135f23766f6b9cfd0fa75e643fe69005251" => :yosemite
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
