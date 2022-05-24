class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.19.3.tar.bz2"
  sha256 "0f812e6e9d2786ba8f54b960ee563c0663ddbe2434bf24ff193f5feab1f31971"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e19bc76fc467de84316114ac9cd5456777ec2d26ca5545895e2a25528bd1c3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c264994ad25a15c84c92929eaf5dd8ca14c10938f58be3161f58ffcebbb3eb07"
    sha256 cellar: :any_skip_relocation, monterey:       "37755208d3543eba393850f25bbc8d57bb8bfe66dedcc6e1ad0168eb750f0821"
    sha256 cellar: :any_skip_relocation, big_sur:        "75380fbb4f54df33cc028ca19b05b7350fc0ee864dbe6e4ee6a4fa9cdec19ad9"
    sha256 cellar: :any_skip_relocation, catalina:       "3aebaa717cf69676ff38b74538a34b3ab96e6344a2303da8f12f420a66b73719"
    sha256 cellar: :any_skip_relocation, mojave:         "17d679f4c969c41701b1dcb897957f5772555453aff321eacff94bf91cf19e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e19bc76fc467de84316114ac9cd5456777ec2d26ca5545895e2a25528bd1c3e"
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
