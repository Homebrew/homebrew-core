class Rkflashtool < Formula
  desc "Tools for flashing Rockchip devices"
  homepage "https://sourceforge.net/projects/rkflashtool/"
  url "https://downloads.sourceforge.net/project/rkflashtool/rkflashtool-6.1/rkflashtool-6.1-src.tar.bz2"
  sha256 "2bc0ec580caa790b0aee634388a9110a429baf4b93ff2c4fce3d9ab583f51339"

  head "https://git.code.sf.net/p/rkflashtool/Git.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b049c39dfe71266669ed37b0af50f5d1fa981963eee08abab29a8cfb32ccc23f" => :sierra
    sha256 "6e129daf2945875ed2f3d162cc4705e1643d826e910574d61d7947c96de007e5" => :el_capitan
    sha256 "6c42ca5e0a23c0e246b6e58baff3a32215ba94e60115c8ef4f38306dadfabbeb" => :yosemite
    sha256 "1f3260720ba6ca946000f10f3675140d8b5e737e6fd18abe7b5c0cb4f7b2d972" => :mavericks
  end

  depends_on "libusb"
  depends_on "pkg-config" => :build

  def install
    system "make"

    # No 'install' method found in Makefile
    bin.install "rkflashtool", "rkcrc", "rkmisc", "rkpad",
      "rkparameters", "rkparametersblock", "rkunpack", "rkunsign"
  end

  test do
    (testpath/"input.file").write "ABCD"
    system bin/"rkcrc", "input.file", "output.file"
    result = shell_output("cat output.file")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_equal "ABCD\264\366\a\t", result
  end
end
