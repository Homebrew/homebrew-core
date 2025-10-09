class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6996b37cef43a62bfd2c99e7b93ec465a3d086ca5e7a0be35ce32ecf5685e5e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f7e71eb3e92c9f824271445b6bc9acedef1fab585256bfb96166685cf02326f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a35a350cbb0b833e804dc0512eca3a5b730f3c982795a008300bed6f903ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd1de69079b2dc705459349aeb10e7b1f9185e93871cd562058a1471a7bb5fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c190daa017dca0b5eeb53f23df6efb607995a8e0df7223a99d55b7db1471ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01a2fda10ce89efe876b1dfdb63a5e4891670b66ed3f9f815ec14de591f60b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9467ef9bb64060bcf096643b2affbd0b234ed23f9558e6190010b794e65f73"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    TCPServer.open("localhost", port) do |_server|
      output = JSON.parse(shell_output("#{bin}/somo --json --port #{port}"))
      assert_equal port.to_s, output.first["local_port"]
    end
  end
end
