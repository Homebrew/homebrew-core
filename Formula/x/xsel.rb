class Xsel < Formula
  desc "Command-line program for getting and setting the contents of the X selection"
  homepage "https://www.vergenet.net/~conrad/software/xsel/"
  url "https://github.com/kfish/xsel/archive/refs/tags/1.2.1.tar.gz"
  sha256 "18487761f5ca626a036d65ef2db8ad9923bf61685e06e7533676c56d7d60eb14"
  license "MIT"
  head "https://github.com/kfish/xsel.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4b77e0f9695c3024acfae203e697084bd2dc38dedfa687df634a44edff53b570"
    sha256 cellar: :any,                 arm64_sequoia:  "b4ef9c989ee8e286f69314d95de96579f0a33336fb5b673b494c27f764c25998"
    sha256 cellar: :any,                 arm64_sonoma:   "7a9deb3b1b185ac5194306be64ddffe8d129d9fb7bd0821eb1ad81fa264d790a"
    sha256 cellar: :any,                 arm64_ventura:  "29489463a6b648ef30fbc0e363941121d979bac946ed00592c0d2f513717554f"
    sha256 cellar: :any,                 arm64_monterey: "bc9e0c0ca69e907dfa5b3416a57300bc7aa1a5a1f08d313175cebb4d0a00b401"
    sha256 cellar: :any,                 arm64_big_sur:  "8d46290837243fe999ac0f72b739104dbc8eb05b2ad78282bc4f2398c9bda4c5"
    sha256 cellar: :any,                 sonoma:         "30b8b58e19c546b6719381fc5e24dbef2e8cc57d0e07c504b35e6f84b7e2879f"
    sha256 cellar: :any,                 ventura:        "46abd92de37296f5be3201a7d4b50e92e10c42a63a4bfd29cf51055cd81d099f"
    sha256 cellar: :any,                 monterey:       "6258269b70ace163a73341c5acb23161660f2bc0b1605086d93540845b926373"
    sha256 cellar: :any,                 big_sur:        "b52227ff66ee16f9e91938370c77e2658ceff2ec2f13ac812ba2920861322450"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "13f84b482a58030b9f25ce9dc75bf06a10328963ea7a95eab43484e859ed4a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "508a55a542e6d8fbc46e3d5b0356bab11270e898353dada474a76f6ea1369891"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libxt" => :build
  depends_on "pkgconf" => :build
  depends_on "libx11"

  def install
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Usage: xsel [options]", shell_output("#{bin}/xsel --help")
    assert_match "xsel version #{version} ", shell_output("#{bin}/xsel --version")
    assert_match "xsel: Can't open display", shell_output("DISPLAY= #{bin}/xsel -o 2>&1", 1)
  end
end
