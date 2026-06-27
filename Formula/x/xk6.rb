class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "d94c601185883a11ddb07e76d5f56967c80bac4b17074983260aeaac437a7bad"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ccaf3c64bb6b5d241ca138c5758011bc5e41951dd38236a61f3ebba2da53902"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ccaf3c64bb6b5d241ca138c5758011bc5e41951dd38236a61f3ebba2da53902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ccaf3c64bb6b5d241ca138c5758011bc5e41951dd38236a61f3ebba2da53902"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6e76cc15287c83262a2e6eee30d6bb8cc3e245285b1882c9ccb654a04aca10d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a58b9eaf6286b2f0cbabec319004c1aac16de51af37aa73c1320faaafdcd5c87"
    sha256 cellar: :any,                 x86_64_linux:  "a535c670ee6e3b2264552fe07e14cc46b219877ddc428a5d3d4d21269ee11bf9"
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
