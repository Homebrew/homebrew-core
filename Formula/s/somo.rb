class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6996b37cef43a62bfd2c99e7b93ec465a3d086ca5e7a0be35ce32ecf5685e5e0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1e4a32220ea96d4283cffda348749c885d43f2b3834f9e306691e5fc6ac763c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb8e0c668adb150edd002fa4bc9b224f86cd141ee9421e00a107f00b2629eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87af655d47845d6eacc5d7a217a0efc09a4088d7bdfdbe1ef9af898411010595"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb59ce4399c33c94add85e8b5861196cfea87fc045dd2ef4b69bfcb71722df96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43ff516d2765ad335067b0545c272fd1a329b60d0b21ccb505f729687379d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e59b3ca9e13adf08d2d0ea12ca81311e61ed092a2e059239abd9db73b2a79fce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"somo", "generate-completions")
  end

  test do
    port = free_port
    TCPServer.open("localhost", port) do |_server|
      output = JSON.parse(shell_output("#{bin}/somo --json --port #{port}"))
      assert_equal port.to_s, output.first["local_port"]
    end
  end
end
