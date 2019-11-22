class Rkflashtool < Formula
  desc "Tools for flashing Rockchip devices"
  homepage "https://sourceforge.net/projects/rkflashtool/"
  url "https://downloads.sourceforge.net/project/rkflashtool/rkflashtool-6.1/rkflashtool-6.1-src.tar.bz2"
  sha256 "2bc0ec580caa790b0aee634388a9110a429baf4b93ff2c4fce3d9ab583f51339"
  head "https://git.code.sf.net/p/rkflashtool/Git.git"

  bottle do
    cellar :any
    sha256 "19915af37cac5f04cea6d0aa71a533ce6fd2a9aa549820286736b526e4be80cc" => :catalina
    sha256 "192628d1c348870f6ea1bc381aeb87023cc0bd19b2c198ea3c14b63e954db88e" => :mojave
    sha256 "72e99558b94cd4e26a5aeb62209c99e03f8e91059fbfbe83bdfbd755fc83f54f" => :high_sierra
    sha256 "cbeb2509bcd210026250c915a9909e8f056e9e2da1f599d7a611695c334f4966" => :sierra
    sha256 "7a8b5c66395b179ce38845c36369b1a65c6eacc73fd29227809597257669af6d" => :el_capitan
    sha256 "cf5c51c7aa18c9304ade585c82d9083421eafde114ef6ab22736a24f45530226" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"input.file").write "ABCD"
    system bin/"rkcrc", "input.file", "output.file"
    result = shell_output("cat output.file")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_equal "ABCD\264\366\a\t", result
  end
end
