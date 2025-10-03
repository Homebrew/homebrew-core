class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.16.tar.gz"
  sha256 "23a14d0d38a2fcf48212fc2ce363039b332e8a0ca910f9210fd219c82ce44ca6"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8c886b1f88729f3fff662a7447255896d6df4ec4e31151821e708b8b84a2348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "823da9036a92c50c9c274a6fab66f6b5aec820c0cb892ccd507c405dcbdbbb13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c49fdda1bdd3b9f0874f64ae4265fd6779f42493cf0e6a530018f38f02ee701c"
    sha256 cellar: :any_skip_relocation, sonoma:        "557a4e0f65de26ea073aa4c2defdd526dae9b51b400de5b2b45936e24aae3d28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b46dc728dff1df625f0e8980195780618a5862ee7d9acfa2806e30815c5dd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f520982edbe186ceb4b5b0286e690b5d65cb0bd86655bd00213bc11524a5d2"
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
