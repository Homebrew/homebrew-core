class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.3/snapraid-11.3.tar.gz"
  sha256 "d35ad92157936db3411e2cf7325665fc59e2d159204f9424895cfa9f33122af1"

  bottle do
    sha256 "48610c70ee6cfa3ceb3724e19b0d6ca3f88bd552a57aa4a1b15b4c5da4170e7a" => :mojave
    sha256 "a37ca63751fbe401c7239e4adff594d051e4eb9ceb11c4db594a927fc652e680" => :high_sierra
    sha256 "e2ffd2c3da613bed66b2a14d682c90703b561b19101ff7f4dbf2864d2107e995" => :sierra
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
