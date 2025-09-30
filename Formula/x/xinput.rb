class Xinput < Formula
  desc "Utility to configure and test X input devices"
  homepage "https://gitlab.freedesktop.org/xorg/app/xinput"
  url "https://www.x.org/pub/individual/app/xinput-1.6.4.tar.xz"
  sha256 "ad04d00d656884d133110eeddc34e9c69e626ebebbbab04dc95791c2907057c8"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c8e2d341b5603fdbf07d9ec892b235a61f69ab54e0b6911969064766a6b1976a"
    sha256 cellar: :any,                 arm64_sequoia:  "c70d8603d13e94505f514890678cef419551a0ac6688356fdd28e6ecaad1fffd"
    sha256 cellar: :any,                 arm64_sonoma:   "2f027d634882891977ee75bdd55f1cd68a7498cf32b036cbd551c8e9a42f4d81"
    sha256 cellar: :any,                 arm64_ventura:  "751c32f1673020bda208c9885345be27da828cc2028e90e76e6ccc26f7d30d39"
    sha256 cellar: :any,                 arm64_monterey: "44bad70ccc176511f7a5d965d028b3ff27b66b820fec7d46c40bf8f72d0d14cd"
    sha256 cellar: :any,                 arm64_big_sur:  "0cc93fd8d5b16c85a027871ddaeb81d25e72eea433f4bd16ea60d30ea75ecac6"
    sha256 cellar: :any,                 sonoma:         "b63fde9b48bc4477a6a4606ffb121f6ea86c9d388d6723ad1a46f5cd80656d62"
    sha256 cellar: :any,                 ventura:        "fc941b892085cf448f2fb8f560d0f7bf4b1ae9d50bd3fde91c09618cfb38ddbc"
    sha256 cellar: :any,                 monterey:       "dfc3f16159f75487037348ee85a29d539376fd3e168417174403b4a3c0942a13"
    sha256 cellar: :any,                 big_sur:        "e21d1963e880afe1acc8001912fc0d091797e664a5dce9d8e9738700139aea3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ec5a8a49c566256840876bb3ffe0d4748343b7ba863c30b3c045c7cd39f59dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48811518afc1be944c7f11606493feeffa4acd7653ad98f80e2dd583e6144bf0"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxrandr"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_path_exists bin/"xinput"
    assert_equal %Q(.TH xinput 1 "xinput #{version}" "X Version 11"),
      shell_output("head -n 1 #{man1}/xinput.1").chomp
  end
end
