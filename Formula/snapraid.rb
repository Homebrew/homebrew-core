class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.5/snapraid-11.5.tar.gz"
  sha256 "1f5267261bdbcf4d48b9359ce67184df11905590739140f740327fb73bcecafa"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d92da7dbdf737efbbeee7025c7d1ed0bc01c1f3cbaf29f0b8ded4b264ff627e8" => :catalina
    sha256 "8ccbba9450a1f49a2d1b9d0424d9dee7ffaac4348f0cf4edf0bfb2b8858f5885" => :mojave
    sha256 "db38538cd61796483d63bb4cf8aa687f8801796abb4074e2a5a69e8cefcaae96" => :high_sierra
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
