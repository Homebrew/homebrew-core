class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "9e8e07bf49696a4048e0b6f1c6ad599a29a79783c9b2e150fe2f3dc9ca6f2e42"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9278d29d32a5949a0c4e0914d436d2e80e2c2dcfb80c596291fa88317f51410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9278d29d32a5949a0c4e0914d436d2e80e2c2dcfb80c596291fa88317f51410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9278d29d32a5949a0c4e0914d436d2e80e2c2dcfb80c596291fa88317f51410"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebe680ff03005f313b10af5fa9bbd94dd2aa71494dd4d3ded28fba659c1b3a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d0b2c579ae03773a417525077f1aa095cccf8dbf4c8f958f9acd11ef56d58f"
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
    chdir "xk6-testing" do
      lint_output = shell_output("#{bin}/xk6 lint")
      assert_match "✔ security", lint_output
      assert_match "✔ vulnerability", lint_output
    end
  end
end
