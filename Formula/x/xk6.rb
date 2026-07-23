class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "01704695d60d5ce7d8d51531a9bb13aeb293509aba4c4097e409a0bb03ef38df"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f738c869a77cd60a6fd2479ed598c9de50edbbed2f7de5ee591d060bb25ec67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f738c869a77cd60a6fd2479ed598c9de50edbbed2f7de5ee591d060bb25ec67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f738c869a77cd60a6fd2479ed598c9de50edbbed2f7de5ee591d060bb25ec67"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3427812f4019b99e1844cd9800c0070daf6ac0c9876d342a6b5dd9b4635c46f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f4b51434129e4419d24a3d7963714cd93cb34e0b5ade0fc8b6060925803081c"
    sha256 cellar: :any,                 x86_64_linux:  "7e609f31f230fe8e45f0d9c1adc07f755d41c855f58370afa20b90a7a956c1d3"
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

      lint_output = shell_output("#{bin}/xk6 lint --disable=vulnerability")
      assert_match "✔ security", lint_output
      assert_match "✔ build", lint_output
    end
  end
end
