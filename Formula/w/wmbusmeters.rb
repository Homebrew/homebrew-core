class Wmbusmeters < Formula
  desc "Read wired or wireless mbus protocol to acquire utility meter readings"
  homepage "https://github.com/wmbusmeters/wmbusmeters"
  url "https://github.com/wmbusmeters/wmbusmeters/archive/refs/tags/2.0.0.tar.gz"
  sha256 "600beb099bc1ac1d4fd7a78dde89bb753b033cfd9de54ed6f25d3fc705c38042"
  license "GPL-3.0-or-later"
  head "https://github.com/wmbusmeters/wmbusmeters.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f22d9a9d1e4c5bb6d912e13d8811c692d16604b3e4d074c5293e23b053fe4967"
    sha256 cellar: :any,                 arm64_sequoia: "4fa18e380b5cb8a92374cf71e510751e30ebcacf1d9279781bd0561e4841197d"
    sha256 cellar: :any,                 arm64_sonoma:  "ee30d71218607fbd64fcf18921f9657d224af6a3042bb67c0217836a77a40ad1"
    sha256 cellar: :any,                 sonoma:        "9dafae198efc565d7bbb344784eac5bddb19a60cbcd88afe4ee659cf45b0a0a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2451083cdca31570262efa096b9384bfc2ddc336dd891c1b67e7511c0245ca4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7890d501952fcaf0823ec5f3eccf7e28f70716c1a1a7d193d0c0e589fdb4f262"
  end

  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "libusb"
  uses_from_macos "libxml2"

  def install
    # TODO: remove on next version bump; fixed upstream in commit e9ef936d6f18f8
    # Prevent configure from running `find /` to locate libxml2 headers
    inreplace "configure", "LIBXML2INC=$(find / -name xpath.h)", "LIBXML2INC="
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
  end

  test do
    telegram = "234433300602010014007a8e0000002f2f0efd3a1147000000008e40fd3a341200000000"
    expected = '"a_counter":4711'
    output = shell_output("#{bin}/wmbusmeters --format=json #{telegram} MyCounter auto 00010206 NOKEY")
    assert_match expected, output
  end
end
