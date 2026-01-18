class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "fe1e6a216cd5f6c73dca5540487a13d6cd8251bc38a87afff1c56a5e88d334b4"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95bee8691f69b5dd89a9748d596b9aa714ea1e55eeeb75532116f3b0c6376b11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95bee8691f69b5dd89a9748d596b9aa714ea1e55eeeb75532116f3b0c6376b11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95bee8691f69b5dd89a9748d596b9aa714ea1e55eeeb75532116f3b0c6376b11"
    sha256 cellar: :any_skip_relocation, sonoma:        "10ed75c23d471906fbbbc0eb1177ee6b64c728e4d30de99f2f69348ca821a0de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db0ddbc9af334bbad51867d44352f632f592163ed33c4262aeb6253b23e04ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe1f7d476ae5cfcf3b9971ffeead096e20f05c445512f195186aa4692231b36c"
  end

  depends_on "go"
  depends_on "gosec"
  depends_on "govulncheck"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X go.k6.io/xk6/internal/cmd.version=#{version}")
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

      lint_output = shell_output("#{bin}/xk6 lint")
      assert_match "✔ security", lint_output
      assert_match "✔ vulnerability", lint_output
    end
  end
end
