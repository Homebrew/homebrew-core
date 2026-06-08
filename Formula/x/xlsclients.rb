class Xlsclients < Formula
  desc "List client applications running on a display"
  homepage "https://gitlab.freedesktop.org/xorg/app/xlsclients"
  url "https://www.x.org/archive/individual/app/xlsclients-1.1.6.tar.xz"
  sha256 "909810a3fdbd01d84747907f2c0cc32ee732e77afc88cb310abb9d155b2a0807"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de8b373a41ebd5e17c797c17c87b95b5d0e0711625ffd981f4bb5b7e92e16154"
    sha256 cellar: :any,                 arm64_sequoia: "3f190e3dce6a1e068753fccf4c63afcb74cd5264a6abda2662238ed9a502d3fc"
    sha256 cellar: :any,                 arm64_sonoma:  "51e9d5978bbbb136a1e1bedf72ec268a81dee67cabd1baca70f8e978205665b6"
    sha256 cellar: :any,                 sonoma:        "648f84da414aa30d72380c4c71d3c97bff3758fc1ec08c6d9ae28f82cb729f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8645f20b8adf3f934f0109d493c4874a376da5d0d3d1096b3ca57a0ca55e4d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f4bcee55c5591705accdd74b8eb08d0b6e373da0e0696c1eb31446bdea6156"
  end

  depends_on "pkgconf" => :build
  depends_on "libxcb"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xlsclients -display :100 2>&1", 1)
    assert_match "xlsclients:  unable to open display", output
  end
end
