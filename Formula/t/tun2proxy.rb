class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://static.crates.io/crates/tun2proxy/tun2proxy-0.8.7.crate"
  sha256 "62fe12ec15b4555ef3068d1082e5fab7d366bd65ba59127990cb917ed5a1f2e0"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    manifest_sha256 "489b59936395dbadd8db145e97c06219257a0e30de5a3469bc39c5dd6570eb93"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a14b27d9ce0204f60052714ba992da88e76f974d35c22e3eb66d2c06ba5ffadc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd928d889203c515849ead18944ba560cba0e5d0539175092188bb891c9fb948"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc620b66cdd4d3c3c40f513f76a238e5a336aedadee90fc2ed5b28cf1f9d6692"
    sha256 cellar: :any,                 arm64_linux:       "97f36bc4656e121e8da3d769e0ceb36b3e9eabbc19c5da9ccd02bc92017b29bc"
    sha256 cellar: :any,                 x86_64_linux:      "611a3d7bc8dd73619734e0d472045d0df258c78a1ed6e915444d191126338f48"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")

    expected = if OS.mac?
      "Operation not permitted (os error 1)"
    else
      "No such file or directory (os error 2)"
    end

    assert_match expected, shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1", 1)
  end
end
