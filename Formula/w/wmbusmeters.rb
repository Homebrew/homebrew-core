class Wmbusmeters < Formula
  desc "Read wired or wireless mbus protocol to acquire utility meter readings"
  homepage "https://github.com/wmbusmeters/wmbusmeters"
  url "https://github.com/wmbusmeters/wmbusmeters/archive/refs/tags/3.1.0.tar.gz"
  sha256 "bb4f739551093167fb22dd65b618536d62b99fb7b7fe5335edbfeb382d391a28"
  license "GPL-3.0-or-later"
  head "https://github.com/wmbusmeters/wmbusmeters.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fd1faf6f31181ec2deb3a134d4536defc162cb7b118d4af95b8d8b08a0e551e8"
    sha256 cellar: :any, arm64_tahoe:       "53bc61ea9e80426a33b0537c80f10e1f953567b46408eb3c562a0d675f40971d"
    sha256 cellar: :any, arm64_sequoia:     "9f2129437a8a224d5daf2a0e9a97cd2dbd58592c50f47ce8725e6e4d370a1ad6"
    sha256 cellar: :any, arm64_linux:       "8db3d80bb2b1b913d70c3b290e801447698feb256a441dbf738b5353c6e42193"
    sha256 cellar: :any, x86_64_linux:      "dde0341287bdedeeaafbc51b5f4fc7d6415355e2be355ce034ef521df25b120b"
  end

  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "libusb"

  uses_from_macos "libxml2"

  deny_network_access!

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
