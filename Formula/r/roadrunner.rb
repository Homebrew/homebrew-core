class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.1.3.tar.gz"
  sha256 "681322fe07cd503a2e36c32ad2a6868f227eb049fa731a528e30ba49a584f6f7"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a68b4cf8190dcdfc3a217cbb154567d18cf925d0683c78dba1a46c3296593bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31ef0a526cd2de2da5daf1e317987b56b6715ffa2376f82504562c80854d16e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3485931a82090ae28b1c78ead18bf102e1e894b2f1d9253deb0cb46a4841796"
    sha256 cellar: :any_skip_relocation, sonoma:         "51b89d8e27315391687d7987150e7d85a6804658ac41e74fb7a021b60e740549"
    sha256 cellar: :any_skip_relocation, ventura:        "dd0b4c4607d635d3d26509435eb9cccd7909e98294b8af141126fab2035d5995"
    sha256 cellar: :any_skip_relocation, monterey:       "6be5aa416b8763272c9a3b0a0f895b9466944b74f8f41f575535920161946d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd8f78204db7715ea2acc0f56dd06d71f4efa2c6566898e71cfb1e724b21e4c7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin/"rr"), "./cmd/rr"

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
