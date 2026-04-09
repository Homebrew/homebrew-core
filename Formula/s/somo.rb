class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "d9c413f302ee59b7fc831180429aabb8f9f62992b1905af5908a12cd7b808974"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c1363126014912e0098a6556e41b5a88b655d7c970a60e52a3536510afdd6fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d04ccf70af132b9532a5c7bfbf0da029776c041f71773938842d64a360b175e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc362a5c3d7913729f2e05eaf2100da251f5026f64723ba16c313eacc568b0ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be693e81126eec7a8c60d5b587a49e5b414ab6b5dc4004fdb3f9353314bc22e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e87388c4d65f096777a86958f8f3fa7a1718a759ea85ee58358c31abfd2c529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5b91764a77c5f387b8fbcb76f7832553c923c3946b4d8b3ce5ec6da6e06b7f"
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
