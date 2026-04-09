class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https://ta-lib.org/"
  url "https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib-0.6.4-src.tar.gz"
  sha256 "aa04066d17d69c73b1baaef0883414d3d56ab3775872d82916d1cdb376a3ae86"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7817d0d8bfa2799e2b90618352a6d276dfa36ff1af3f343c9f4d7fe0be8d6240"
    sha256 cellar: :any,                 arm64_sequoia: "0ef739e4436909635fc3bacd8df2362d37a9467f11631111463dd387776b6b13"
    sha256 cellar: :any,                 arm64_sonoma:  "8d7deb75b383ebc50513ebd077c4268acdb09d602b19ed4c8878f915f8f8b1e4"
    sha256 cellar: :any,                 arm64_ventura: "12709c4df99f1dce0315b653a1bdb962f3cc6c429bda41a13d17f4dd43079644"
    sha256 cellar: :any,                 sonoma:        "c34c5da2df4abefcb86d3f130a7e8fe0b85fad2c83e2343d9e65e4a615c6b235"
    sha256 cellar: :any,                 ventura:       "151e74186d18550800b5e7e714c50e99e25b1e4f536fc83521e45e4ce389fc0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6bc65c4e2fb0d567fb739d473d9ee2b696741bb5d05f0f10c8594e096c875c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "868d1163296be1e3d5f10bcdf4047f0e218eb91617da562eac14fd04cd05433d"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.deparallelize
    # Call autoreconf on macOS to fix -flat_namespace usage
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", *std_configure_args
    system "make", "install"
    bin.install "src/tools/ta_regtest/.libs/ta_regtest"
  end

  test do
    system bin/"ta_regtest"
  end
end
