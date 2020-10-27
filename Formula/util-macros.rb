class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.19.2.tar.bz2"
  sha256 "d7e43376ad220411499a79735020f9d145fdc159284867e99467e0d771f3e712"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "298dfa88698206b08ce19e5daf66903da4a94e561ec639487c17b55c3d09ee3f" => :catalina
    sha256 "bd71cb44913a35fb4f8e63a0fd90229d8912d7af40f02c78b056cf72eb88b684" => :mojave
    sha256 "38d6cb7e6c900a555c5602af513224d346166e109b7226cc5b86cb51b9b55fe4" => :high_sierra
  end

  depends_on "pkg-config" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "xorg-macros"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
