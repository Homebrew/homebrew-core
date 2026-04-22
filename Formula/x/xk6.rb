class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "351d123473f6f67e054493c43cff41aa37eb792b80c8cf8625ff1057cafb5373"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acf58905e286e6651c996d8d1ba7bb51cc0005c8ef831c471a3aaf9a81c38a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acf58905e286e6651c996d8d1ba7bb51cc0005c8ef831c471a3aaf9a81c38a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acf58905e286e6651c996d8d1ba7bb51cc0005c8ef831c471a3aaf9a81c38a92"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a7a3131e3436ddc0f8415bfc7cd993108e57319a3232f3fcccf1b4f33d10471"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98a6db087e4499c556883dce18d33519d5528e2b9a890447e44f68de0261f5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96f804b8603ff5d1bd2ab7cb5d8e3ad9b0f583c06d19715d49a762569cd8135b"
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
