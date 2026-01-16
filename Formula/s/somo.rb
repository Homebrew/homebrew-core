class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "89476469318f3cc9d334ed39f415d0638d79df265929c05a27acb9a372544cc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e79ca29c9937d4153f7c35da4dd8a5981fdf191cccfb3150a99daf99ca8de5af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67436ba102bbe520fb37b375e5c4478acf7a8f0f7d59482ecfb0ea74b5c79984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2d2397f5ffc51d46337533fc9fa0338c77da5539a95115a8bb0777ac27b6cb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d3c573b6cb5dab40236133464a7cf48859612b1d8423a15672806175ea52028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "556d85393b26d3f4b07d11a63fdd1c4138de58ef4d3e5788111abb4c5b7627fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412f433f84e0c26abd8a2a2af8bec2107b30439aee4b411f2e7b7b2d6ee7acbe"
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
