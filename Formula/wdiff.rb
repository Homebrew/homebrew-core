class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"
  revision 1

  bottle do
    sha256 "5f949893137314b6b2f75f4c168b361d0b10a8da76c9d3e31f505bb086315fee" => :mojave
    sha256 "c11b3eecc5edb376ff46d09ac5206bfb05e6b16842535a236a0b19d08dd96295" => :high_sierra
    sha256 "5fc339bce086c8780d7588a27b959d02ce079403166af2f5fd541c44ef4a29c8" => :sierra
    sha256 "51b0625f3708ecfc74c613fdd2cd11cfb706d08da20206ddb5e628e6aedfb62f" => :el_capitan
  end

  depends_on "gettext"

  conflicts_with "montage", :because => "Both install an mdiff executable"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make", "install"
  end

  test do
    a = testpath/"a.txt"
    a.write "The missing package manager for OS X"

    b = testpath/"b.txt"
    b.write "The package manager for OS X"

    output = shell_output("#{bin}/wdiff #{a} #{b}", 1)
    assert_equal "The [-missing-] package manager for OS X", output
  end
end
