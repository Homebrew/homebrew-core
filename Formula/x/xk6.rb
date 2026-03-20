class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "3b6b5f8936758f3ceeb1c7d90816852fe6872199e53bf61696ab79c9594873a7"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e014c51b8939d8a0f65a7b49026b0a5ecce0e375ddb28b20f6a6f3a965e139c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e014c51b8939d8a0f65a7b49026b0a5ecce0e375ddb28b20f6a6f3a965e139c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e014c51b8939d8a0f65a7b49026b0a5ecce0e375ddb28b20f6a6f3a965e139c"
    sha256 cellar: :any_skip_relocation, sonoma:        "81c8805f56e0042d350904f0495fc42b19051985962d864b3ef662e8af1f47a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89d1ce9f0dfead1ad07a08c31408303751c4bf974d80784fe2bfff9a958e1985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9a64432078e9100bdac54b0231b66179516ddb6e81478a7d9b10b78b16924c0"
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
