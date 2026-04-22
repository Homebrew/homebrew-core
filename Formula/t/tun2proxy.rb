class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.20.tar.gz"
  sha256 "f53cac0aebc779bd379d5e4518163d08e6a14f4f3a4a39a0254b49746911062b"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf91ff8a14d0cdbeb09b7c852365ccdb34fe827f38196701518105145e415ea1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac41e2ba5f66f598adb995ae24713a0adf3b715625a070193a0c6e8967e8fc9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e82508e4d08e606489205d281c0893acc455ff0f936157a72833280ecd375945"
    sha256 cellar: :any_skip_relocation, sonoma:        "98622f77f0ea6b75184f508c60b9d950cabbec23db083e7bc0c513f6218a117f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95a2c466632dbc8d93d4779c46a30c4ba84d943282eec500e4c83eb2be9efe48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dec6538603801a874ae927bf7a8c1bb8e0bfd495cf4b024c7f9e4ed845cb464"
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
