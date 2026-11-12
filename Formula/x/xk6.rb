class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/releases/download/v1.5.1/xk6_1.5.1_source.tar.gz"
  sha256 "e36fe66e7c74da3143086d443373ae0199105a10cf54e7e9d05fab70f45a904e"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b44182fb5efaeecaf0f4361a828d522fc74a25275676525d2c5e9dd9afde3b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b44182fb5efaeecaf0f4361a828d522fc74a25275676525d2c5e9dd9afde3b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b44182fb5efaeecaf0f4361a828d522fc74a25275676525d2c5e9dd9afde3b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f83a0d07591e3f393312611351f9c73bb39e4c5abd5eef0a83550add1a751afd"
    sha256 cellar: :any,                 x86_64_linux:      "2c892dcf2a7b2afb45ccf92a2bf3f53d0b9cbeef43ac1ef76865987d9c55425f"
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
