class Skymaker < Formula
  desc "Generates fake astronomical images"
  homepage "https://www.astromatic.net/software/skymaker"
  # Upstream URL is currently 404 Not Found. Can re-enable if upstream restores URL.
  # url "https://www.astromatic.net/download/skymaker/skymaker-3.10.5.tar.gz"
  url "https://web.archive.org/web/20161206053718/www.astromatic.net/download/skymaker/skymaker-3.10.5.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/skymaker/skymaker-3.10.5.tar.gz"
  sha256 "a16f9c2bd653763b5e1629e538d49f63882c46291b479b4a4997de84d8e9fb0f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a64d0196f49aabd48d626c7b2585e61faa5812eae14a914f884733fb8a9dd754"
    sha256 cellar: :any,                 arm64_sonoma:   "3b60d5073126dc8d3d74b4c96855b082aa49fc6d5b6a56340d14f93b746c0b15"
    sha256 cellar: :any,                 arm64_ventura:  "27e46c46cf30f77353d447b24629b1d2824c70369fdcd08307be2e0984a0fb3e"
    sha256 cellar: :any,                 arm64_monterey: "41786c90ee63b22f0d1a582dc7b42ed9aa9a749e4be35772169805c6b7804510"
    sha256 cellar: :any,                 arm64_big_sur:  "44e3eadc4f4a2984ffff332f93e9aa7a383b7a395ccd9fd6714a237a48ed72d0"
    sha256 cellar: :any,                 sonoma:         "c8c9e031c32c25775d91f93fd7f580c8bd04f63e408eafa607140fd200cad972"
    sha256 cellar: :any,                 ventura:        "b535c7f706a5139cde6cbbb0893009287cc2bf7062474f90de68a557ba3a4397"
    sha256 cellar: :any,                 monterey:       "9c6b33e5127676aaec7d1d8c0232fb78be8a0bb8a5ee4fc429e0516b45e0846c"
    sha256 cellar: :any,                 big_sur:        "2262e9a1f11f41c75fc8ccb47717f779bbb62bf86ddbabd42975fe684278efb9"
    sha256 cellar: :any,                 catalina:       "af78e7af9c84517e8f7db071ef3718a34eafc39d6eac3357d77ee183d4fe2cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fa9e4c7c056d4a8465d105e059ef46c1256724d5dbe879c6e26ef218390e5fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10fd94a91d3a556bbc800e809c596451cd08893656ad8f2205759e2016411328"
  end

  deprecate! date: "2024-06-10", because: :unmaintained
  disable! date: "2025-06-21", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "fftw"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    ENV.append_to_cflags "-fcommon" if OS.linux?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "autoconf"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "added", shell_output("#{bin}/sky 2>&1")
  end
end
