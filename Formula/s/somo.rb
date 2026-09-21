class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b084d1617055f39f17e3ae08fe1fdba023b43f8f928c8edf53af0f8ce8a2b14a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8826ef546d774f92e50abe497ebb76c2e43540523e3f01d4174fd9f6789bd353"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "146bafc46a5f5f0a5bb07d27125b058d791b704bb60a53ab124b01e820b2e84c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68702415cd111e77cfec890ff7d5b43a9d31f8cde891780f7976337f3d574013"
    sha256 cellar: :any,                 arm64_linux:       "dfdd0700a294c6a63d425abb579f9fb7c7d905f39276cdda938cb3bf809eac37"
    sha256 cellar: :any,                 x86_64_linux:      "4b27bdc8f7a688a694eb3b736ac0a27da9dda1d48288ea12ee862516e72620cc"
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
