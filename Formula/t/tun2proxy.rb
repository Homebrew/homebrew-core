class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "85c467d3cfd7512f16596161fd8b7da912711a7aa3a9f4cf12877ba482143f9f"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c242daa0a2c886c8346585c1777dbabb1de956d0b0e55b91b4905013db4ecdbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e20c9949c607fd5ce0e04ccf113b7400e55ad1769fbe2d780441d7996240b8b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e361a130aa02b10ac03d286f597815c364755a7b7e77c20e8d60f134403a4629"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3305dd85bc551ac80fb7210db425c8d8264b04be45f6b610181aebadcbdb6bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dcfba492c9d8923a62aa701da1a93ce459bab15893b9606df072b9a393ab840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ba6d9f98c511ac9b84e6d2885f2393bd67bb9df10a0139b682587be088dea7a"
  end

  depends_on "rust" => :build

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
