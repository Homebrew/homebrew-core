class XcbUtilRenderutil < Formula
  desc "Convenience functions for the X Render extension"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.10.tar.gz"
  sha256 "e04143c48e1644c5e074243fa293d88f99005b3c50d1d54358954404e635128a"
  license all_of: ["X11", "HPND-sell-variant"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4f0545144b6e7c459497ebb586c522a1d3b3b5eef1160987fbe5b45e275a026c"
    sha256 cellar: :any,                 arm64_sequoia:  "098b22877ee1d5c2c16b1827117f13f95566c1bf06d042943170c6590a06e379"
    sha256 cellar: :any,                 arm64_sonoma:   "f2533358b260aa2fb9f819e75a259123791bb4838b2bd1a2986f756e248c3109"
    sha256 cellar: :any,                 arm64_ventura:  "2ed461a699bf32016f2a95f313ed16c492dfedd98249dd86b2b6e558374fb0ae"
    sha256 cellar: :any,                 arm64_monterey: "295e5e58b68d75ee1938c78dda67904e0ba42ed6173357ea357f22140069b7dd"
    sha256 cellar: :any,                 arm64_big_sur:  "e9b427a9928e8cf63481ecb3a3d1bbc9ac4091df0229c6bfde4735a723e0e073"
    sha256 cellar: :any,                 sonoma:         "e774fa85f56ee12251edbf29a61b54f4d82715939b8fb9127b62a134cdd1f1be"
    sha256 cellar: :any,                 ventura:        "825d17209bb9384ae1f65cf1e909653151e2ba290c39a4ca20021f6a732133ef"
    sha256 cellar: :any,                 monterey:       "2f416f529c5764d88b98ea0c29d1afad765affb466aa69e465d998b7bd042fba"
    sha256 cellar: :any,                 big_sur:        "3a61dcebbe56e1dcff526e7ea2fe39007bf8bc1b40900f230ab4d3d318e40211"
    sha256 cellar: :any,                 catalina:       "444c4008a4d37a2a687b13316302e1fc67a1794f9bcb83f91d23e9e4ba532ad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e290a280c48d596dd1946a5d3d8670ce85b6d24ecdd565d2c46106fdaa8128f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de153c6d1351a146e6cd98c7b8b0b5dddc413dbbc5baa739d3310813186839d"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-render-util.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libxcb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-renderutil")
  end
end
