class ServerGo < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.1.77",
      revision: "1c096fa17a6b529bb0002c224c9b035df368f30e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3209d8af70df99fe6e18745742bf1676eb4839a3c15c3fd03ba5416c2ed67234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b528abc2bddbaf803d475fbb23758db2c018704c34c9b5c492b0a7f29f3fd9c"
    sha256 cellar: :any_skip_relocation, monterey:       "93b4532f5bd3c808e74225db0deec2aff1bc0f585eaada465dcfb3df70b6602f"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b01c329bbf329c08da2d827c3891659f7a82eb15913b5f666cad9ca835d5eb"
    sha256 cellar: :any_skip_relocation, catalina:       "d0c6e7d29e40bdf3535103019722db0dcfdc787e18747b1b3c72b87f7a52c33a"
    sha256 cellar: :any_skip_relocation, mojave:         "80bf7c30103432008ea9fe2e5dea8d32de5d71e0d563e2a5c0aa59192238dad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c575de6caf4916eedf3791c3efb703153f171d9b12c3ba9e9bac579b86d2fe6"
  end

  depends_on "go" => :build

  def install
    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", "-ldflags",
      "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew", *std_go_args
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"server-go", "-c", etc/"server-go/server-go.yaml"]
    keep_alive true
    log_path var/"log/server-go.log"
    error_log_path var/"log/server-go.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/server-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/server-go init --config=server.yml 2>&1")
    assert_predicate testpath/"server.yml", :exist?
  end
end
