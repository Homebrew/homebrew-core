class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "https://ftp.gnu.org/gnu/rcs/rcs-5.10.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/rcs/rcs-5.10.0.tar.xz"
  sha256 "3a0d9f958c7ad303e475e8634654974edbe6deb3a454491f3857dc1889bac5c5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a16720713ee2f30c3f126ca4716b4df5e1e5e68c24d31fd93ea312c2900d2b4f" => :catalina
    sha256 "fddb77e2b68d2f0f4f8264d7c44127cb0bd407a275e4123f5096f89be4734fa7" => :mojave
    sha256 "f429e435048ad65275519c990aa4c2c437fd3b5d682865c057fe7f001e93946f" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
