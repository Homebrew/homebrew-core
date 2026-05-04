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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fd28b7a232aca96f771d81145060d128d913b33a48a353e7a1e4de3d8acce34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd28b7a232aca96f771d81145060d128d913b33a48a353e7a1e4de3d8acce34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd28b7a232aca96f771d81145060d128d913b33a48a353e7a1e4de3d8acce34"
    sha256 cellar: :any_skip_relocation, sonoma:        "2863a9e9ff3a750f71d9b4a35d8813f7999e21da8cdd50fd271aa1e4623ef9d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a89e6800a7fcd1e4c3debf40150757e1961fb92e9b819b7fbff31593abf8b540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "057168de2a343babe14ab50b7e6b516e9df68d08ec6ab4ecdddc1c4f7eb1d33e"
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
