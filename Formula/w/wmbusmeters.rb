class Wmbusmeters < Formula
  desc "Read wired or wireless mbus protocol to acquire utility meter readings"
  homepage "https://github.com/wmbusmeters/wmbusmeters"
  url "https://github.com/wmbusmeters/wmbusmeters/archive/refs/tags/3.0.0.tar.gz"
  sha256 "d1bfc90db81e0340b806151f6c05337e9a0be3d5418c625e18bb137f45fb6ed7"
  license "GPL-3.0-or-later"
  head "https://github.com/wmbusmeters/wmbusmeters.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6fe2c42deaddacdd876bc496e814ee84c2821ee9d38f2cc86b760b7538bb42c5"
    sha256 cellar: :any, arm64_sequoia: "c31c6432c57e2a1bcb220fbed474f5ec6a0b0c57bebb2d1cce2a355e4fa5673c"
    sha256 cellar: :any, arm64_sonoma:  "9ffbd595ef709f53a2181a134d6f1d88230ecfcbbd10bb708a6779fc2994b831"
    sha256 cellar: :any, sonoma:        "b925711df363a619dabd00d46f780d4a72e612be4cabb0554b444847a6a10d6b"
    sha256 cellar: :any, arm64_linux:   "d012dacb1ad806412121128c76ed5c62dde3480efbaf2f14b2a94e411f559c32"
    sha256 cellar: :any, x86_64_linux:  "29171c7a663c1f19b054d22c8f9f51153a614f3d88c7748bd6531565be40b603"
  end

  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "libusb"
  uses_from_macos "libxml2"

  def install
    system "./configure", *std_configure_args
    system "make", "TAG=#{version}", "BRANCH=", "COMMIT_HASH=", "CHANGES="
    bin.install "build/wmbusmeters"
    bin.install_symlink "wmbusmeters" => "wmbusmetersd"
    man1.install "wmbusmeters.1"
    (etc/"wmbusmeters").mkpath
  end

  service do
    run [opt_bin/"wmbusmeters", "--useconfig=#{etc}/wmbusmeters"]
    keep_alive true
    environment_variables PATH: std_service_path_env
  end

  test do
    telegram = "234433300602010014007a8e0000002f2f0efd3a1147000000008e40fd3a341200000000"
    expected = '"a_counter":4711'
    output = shell_output("#{bin}/wmbusmeters --format=json #{telegram} MyCounter auto 00010206 NOKEY")
    assert_match expected, output
  end
end
