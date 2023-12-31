class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.8.tar.gz"
  sha256 "372cb025c55daa4390c37f454079bb96b7a67a6e8ed1e9eb9be557b107db7cc8"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "046a4f916f30882db35bf13327cf382c2686c21259306bbf748dbbd9f56696dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "724c74d9a9dd16ee31cee091c7fe05c2c40eb97c684c7d65f08d39610d6e2887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "444f9821d8db041715cddff55e4278eb06d4de595a76867d99bceea755bccdc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "88193c009dda7c02c16e5421e20e579cc91a814379df32b8b35aa0454a01b01a"
    sha256 cellar: :any_skip_relocation, ventura:        "7244c3d39844ad4f791456a10296e5f836c9cd4e9f4fee02a3be2b1138ed37a0"
    sha256 cellar: :any_skip_relocation, monterey:       "128b6b23f56afec01862628dabed8078a9e8c1b582902f2526d03f4edd8662c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da83eadf1dbf01819c374f08ad292405c1811e647eeb78166f4b647eb5c1aa8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(output: bin/"rr", ldflags: ldflags), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", "completion")
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~EOS
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    EOS

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
