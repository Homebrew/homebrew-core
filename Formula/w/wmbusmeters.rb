class Wmbusmeters < Formula
  desc "Read wired or wireless mbus protocol to acquire utility meter readings"
  homepage "https://github.com/wmbusmeters/wmbusmeters"
  url "https://github.com/wmbusmeters/wmbusmeters/archive/refs/tags/2.0.0.tar.gz"
  sha256 "600beb099bc1ac1d4fd7a78dde89bb753b033cfd9de54ed6f25d3fc705c38042"
  license "GPL-3.0-or-later"
  head "https://github.com/wmbusmeters/wmbusmeters.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "48ed2b6256fd4de5aae0ba88f168edff789455ebeddb45ec2c0b02dcf023ef50"
    sha256 cellar: :any,                 arm64_sequoia: "d9e5e3b1e49de985190abb8b617f48a0f25fde23de7006bdf7fba515b33bccc4"
    sha256 cellar: :any,                 arm64_sonoma:  "914a69c5bd54cc032acf7ea11da5d527e9767fd8028a9c9fc320cde7615bf486"
    sha256 cellar: :any,                 sonoma:        "d6d9021668bcf95ff563644a53219ada239edea1f9b7985f4869855cf74f5f82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5418013076180919d6d8beae685569da60970b1006ddb28d9c6304bd35156a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8eb65c9637ca3517a45909a2ba750ea4c9c6bd3e11d41a90f9edcc818f971bd"
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
    environment_variables PATH: std_service_path_env
  end

  test do
    telegram = "234433300602010014007a8e0000002f2f0efd3a1147000000008e40fd3a341200000000"
    expected = '"a_counter":4711'
    output = shell_output("#{bin}/wmbusmeters --format=json #{telegram} MyCounter auto 00010206 NOKEY")
    assert_match expected, output
  end
end
