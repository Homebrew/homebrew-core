class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "b5a2f550c8b97623c567a46ad04728f379db4b7d0b00763cbf0ec7b4cade388e"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a003aa617c3d84a5eb6ebd57d7bb9080a4596ca9cb59f85792faa0dea2028384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a003aa617c3d84a5eb6ebd57d7bb9080a4596ca9cb59f85792faa0dea2028384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a003aa617c3d84a5eb6ebd57d7bb9080a4596ca9cb59f85792faa0dea2028384"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e5113f441df8457ca02e034291803fdad5b5d02325eab86637a4d7d7257adfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b742a77e3f09067eec01f10f91cbafc5815f84e10bb14b13308190ba7d88f7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4dc6132844a6bc533a3a27a27ef54707b3a1865508817237330e495b46f8c7"
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
