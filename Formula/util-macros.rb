class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.19.2.tar.bz2"
  sha256 "d7e43376ad220411499a79735020f9d145fdc159284867e99467e0d771f3e712"
  license "MIT"

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
