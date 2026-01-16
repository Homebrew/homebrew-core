class Schroedinger < Formula
  desc "High-speed implementation of the Dirac codec"
  homepage "https://launchpad.net/schroedinger"
  url "https://launchpad.net/schroedinger/trunk/1.0.11/+download/schroedinger-1.0.11.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/schroedinger/schroedinger_1.0.11.orig.tar.gz"
  sha256 "1e572a0735b92aca5746c4528f9bebd35aa0ccf8619b22fa2756137a8cc9f912"
  license any_of: ["MPL-1.1", "LGPL-2.0-only", "GPL-2.0-only", "MIT"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "802187a5994506ae665bb01bb4457ec3a3f7f41241f6d1734f59d28c02c0485d"
    sha256 cellar: :any,                 arm64_sequoia:  "a9b3bb16d608978a3bfae464380e4110745808274d336d2e1a31834378b2a487"
    sha256 cellar: :any,                 arm64_sonoma:   "cf37204722b07d4b2918e55aa2f71f4321e8b0b340579dd4e1dbcbcc272040fa"
    sha256 cellar: :any,                 arm64_ventura:  "ada44d9f9a740f64fb2d3f66e55f7fc9f523aef0c160866ee301f54a9a9c084b"
    sha256 cellar: :any,                 arm64_monterey: "7723de84138cae533fd4304aad54edcbb22d9815e8eebd23f8617ae6523a0a18"
    sha256 cellar: :any,                 arm64_big_sur:  "eed0918ea3c7ff3e75968249865c6743b5dd6a444b1022f15926c9e0b3496cfb"
    sha256 cellar: :any,                 sonoma:         "a4eeeabcf00b3a73ae1efd28b5f00b3a92d447dce55d92ffc2d6a88d15e330ce"
    sha256 cellar: :any,                 ventura:        "713177f50bfbaa6d29d889da79eab19ff45b94e2d967514b64650707afa261b7"
    sha256 cellar: :any,                 monterey:       "eb3f714b77e5562bad12a8071a07cb45690ece3b0b8b544b56fc06501e83fb0e"
    sha256 cellar: :any,                 big_sur:        "81ea2f319f7e300c222b2788fdb03bfc3b3177f5a8166caa88afc1b4538b291d"
    sha256 cellar: :any,                 catalina:       "904f8940085832802e511565d1bcea91262a0ca871612509c1e521db37da4227"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2f2674c5ae2910ea63da7347b73cbb12f45f1531babac60af4ef50d82a1f79cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c7db0617f2a2d01b89d446860529fc3520f377e601a460fadc5e3ce2bc0baa"
  end

  depends_on "pkgconf" => :build
  depends_on "orc"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args

    # The test suite is known not to build against Orc >0.4.16 in Schroedinger 1.0.11.
    # A fix is in upstream, so test when pulling 1.0.12 if this is still needed. See:
    # https://www.mail-archive.com/schrodinger-devel@lists.sourceforge.net/msg00415.html
    inreplace "Makefile" do |s|
      s.change_make_var! "SUBDIRS", "schroedinger doc tools"
      s.change_make_var! "DIST_SUBDIRS", "schroedinger doc tools"
    end

    system "make", "install"
  end
end
