class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/releases/download/v1.5.0/xk6_1.5.0_source.tar.gz"
  sha256 "ec4c09b261a26a48f3834518d3ffbf8dedf47750e2583fe5cc1b9637af2d3c51"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97b39ac5c9af0f494fde6fc6ca234ff5ae31f250105fa0a7566ad30bc728727e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97b39ac5c9af0f494fde6fc6ca234ff5ae31f250105fa0a7566ad30bc728727e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97b39ac5c9af0f494fde6fc6ca234ff5ae31f250105fa0a7566ad30bc728727e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "766e9eee73408cc466c601467713772fc30b10343e282db7604e87839dae036d"
    sha256 cellar: :any,                 x86_64_linux:      "64c614e6177a7a9a4437220504e6d10451186506dac5bf787b94dfb4e7740696"
  end

  depends_on "go"
  depends_on "gosec"
  depends_on "govulncheck"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X go.k6.io/xk6/internal/cmd.version=#{version}")
  end

  test do
    assert_match "xk6 version #{version}", shell_output("#{bin}/xk6 version")
    assert_match "xk6 has now produced a new k6 binary", shell_output("#{bin}/xk6 build")
    system bin/"xk6", "new", "github.com/grafana/xk6-testing"
    cd "xk6-testing" do
      system "git", "init"
      system "git", "add", "."
      system "git", "commit", "-m", "init commit"
      system "git", "tag", "v0.0.1"

      lint_output = shell_output("#{bin}/xk6 lint --disable=vulnerability")
      assert_match "✔ security", lint_output
      assert_match "✔ build", lint_output
    end
  end
end
