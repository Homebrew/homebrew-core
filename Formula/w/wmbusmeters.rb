class Wmbusmeters < Formula
  desc "Read wired or wireless mbus protocol to acquire utility meter readings"
  homepage "https://github.com/wmbusmeters/wmbusmeters"
  url "https://github.com/wmbusmeters/wmbusmeters/archive/refs/tags/3.1.1.tar.gz"
  sha256 "973278c4febc57faa15854879d12c0e36beebea9ea5374f15717d7f727b6b246"
  license "GPL-3.0-or-later"
  head "https://github.com/wmbusmeters/wmbusmeters.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e2fd559d09ce4b94e64365709bd53698458bc7311b72e018cd49d1c31638d789"
    sha256 cellar: :any, arm64_tahoe:       "165c7c7669b9723691e0b865a970bc87361181b8baaea3d235604f7b16c74451"
    sha256 cellar: :any, arm64_sequoia:     "3839673c5bfcee34e30287bd63423d54f4afbbadd489331c516d4c1e5a63969f"
    sha256 cellar: :any, arm64_linux:       "ef2840dcfb127f700e435959666ff59b85cc685cb46381a36d5a12511f800a62"
    sha256 cellar: :any, x86_64_linux:      "b6d9f2355e80f75641e8463c9b0013106e967421c619e34fa2f9f7ff6bd3e1f8"
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
