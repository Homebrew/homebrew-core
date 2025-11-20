class XcbUtilImage < Formula
  desc "XCB port of Xlib's XImage and XShmImage"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-image-0.4.1.tar.gz"
  sha256 "0ebd4cf809043fdeb4f980d58cdcf2b527035018924f8c14da76d1c81001293b"
  license "X11"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6f1af8fedcf855ff37794ed6fb607be0a4d560afee79e3fa5ba79ec6bd877d29"
    sha256 cellar: :any,                 arm64_sequoia:  "e7ebd7a81c36003239f80b1fdd67650d6eee527482e2f2f70edc14b631f77224"
    sha256 cellar: :any,                 arm64_sonoma:   "237ce9305294166d1dbd5348b95e75c577511c7b4e69d0203905c86ff5b1ed48"
    sha256 cellar: :any,                 arm64_ventura:  "29c75ea3f0424141fefe9b962c4e8a0ce362c23ef650a905e5118e6833040a85"
    sha256 cellar: :any,                 arm64_monterey: "a4e026015349c95cc815a4875b5b9aa1149888e0f8f3d1bd7075de107e09f524"
    sha256 cellar: :any,                 arm64_big_sur:  "fd3852b6c3b6b93d835cc2f67f60ceb69a2bba35ff61b290e40a55bd325a3b85"
    sha256 cellar: :any,                 sonoma:         "9fb54a1443ff6bd3b08f8a2b2b9724924d60c25ec65383e4949e47ed98456f68"
    sha256 cellar: :any,                 ventura:        "d2c334555a803e4c1df1c5f61482aebe3916600e68ecdaf888f7ed049650b300"
    sha256 cellar: :any,                 monterey:       "f92b6aa70eb06235ba8288bad7b15ad7f02bc718904b84500b6b3372872c6603"
    sha256 cellar: :any,                 big_sur:        "bb01ed34a0c656065eeebf407b5e014f5ecd8a23b0caf231dfeb79e733aa1136"
    sha256 cellar: :any,                 catalina:       "814b9a0c7d70118ee2da43f32311121b9da52f995c790fe4b4143e701a443c8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3a97fcf25d84f03c1114e588464768ef38160faf0beadbbd816c92a25a914bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edac92f05202f6a66955b860ff1a3cf65e851568f6ad6ffce0237af6833c5087"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-image.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libxcb"
  depends_on "xcb-util"

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
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-image")
  end
end
