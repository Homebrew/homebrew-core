class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.2.2.tar.gz"
  sha256 "94fcc6674f7084b5a8aef09e73900c87f87846d304c0921a0166c1318ae4be12"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96f6396b45d0c320f0b0dfdf8a6bdcfba3e5873f6e5a43073c1413e895907052"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "befea8756b1eea72b049edede56d985cf326715503d179c0a793ed19eeba5e1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6365fac068b5819e1ab691a9761a69911c7408257dd834b9afdfd8b96013977d"
    sha256 cellar: :any_skip_relocation, ventura:        "fb2a45c24f32dc4505db2a3cc06cee715076631bd79d95e624a663ebaab5dcb3"
    sha256 cellar: :any_skip_relocation, monterey:       "dc8f2c1f137d34faac29fcfc22bd071770407defaf1393b13e34bbea6f34f93a"
    sha256 cellar: :any_skip_relocation, big_sur:        "94b6185f8417855075bd960460782ae2a92db585e569988198072d3b02f1aa4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20957fef473a7ce18f6e8376c6102631525af40ee532a3633acaa2d1754f2dce"
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
