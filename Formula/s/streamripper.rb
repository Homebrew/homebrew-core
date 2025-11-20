class Streamripper < Formula
  desc "Separate tracks via Shoutcasts title-streaming"
  homepage "https://streamripper.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/streamripper/streamripper%20%28current%29/1.64.6/streamripper-1.64.6.tar.gz"
  sha256 "c1d75f2e9c7b38fd4695be66eff4533395248132f3cc61f375196403c4d8de42"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/streamripper[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f0f900d7d9b50f242d815eb6826684b2e6d2c76f7a3bc58f08ce6f06cd1302aa"
    sha256 cellar: :any,                 arm64_sequoia: "6ec682174a122bdb8b6fdae00b16f25ac6a0325c9c6d0dcb930b03679986f34e"
    sha256 cellar: :any,                 arm64_sonoma:  "fa05b4cc2fe0be48ae3d3ddd929e597a17c35645e0f4609493eb200686da521d"
    sha256 cellar: :any,                 arm64_ventura: "e00ae4c681568844df42dc75ee116a92763644a041542480b8224beda1acc35d"
    sha256 cellar: :any,                 sonoma:        "b193b872eaa4c70fa51fd38c22c378e0143a275a268ddcfcb5721045b2637235"
    sha256 cellar: :any,                 ventura:       "d5c5fcdcfc5cdb06479e7bbfc95de83614ccdfe67b50d30bfbeb89d8ee46e11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "987a8725e3adbfb98f1b5916f7fe4eb5727e61bea35d5265a038473616ceae83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e98a61e5ba076e3a325d7df46e9ec8d90104f15acc1ac302d6307ba984eb053"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "mad"

  on_macos do
    depends_on "gettext"
  end

  def install
    # the Makefile ignores CPPFLAGS from the environment, which
    # breaks the build when HOMEBREW_PREFIX is not /usr/local
    ENV.append_to_cflags ENV.cppflags if ENV.cppflags.present?

    # Work around error: call to undeclared library function 'strcpy'.
    # Ref: https://sourceforge.net/p/streamripper/code/ci/master/tree/lib/argv.c#l33
    ENV.append_to_cflags "-DANSI_PROTOTYPES=1" if DevelopmentTools.clang_build_version >= 1403

    # remove bundled libmad
    rm_r(buildpath/"libmad-0.15.1b")

    chmod 0755, "./install-sh" # or "make install" fails

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"streamripper", "--version"
  end
end
