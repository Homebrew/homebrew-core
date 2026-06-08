class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "74e4745b64f275560d64fa0d737ae3f5acab05780ce54967450589dad957d3bb"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f51119074f197bb10930f2793832da7ed8cb1a1fcd27de208a8356c5801fc87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f51119074f197bb10930f2793832da7ed8cb1a1fcd27de208a8356c5801fc87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f51119074f197bb10930f2793832da7ed8cb1a1fcd27de208a8356c5801fc87"
    sha256 cellar: :any_skip_relocation, sonoma:        "7486ac7b499a49ae7f7655cfcec800662d74ec2dae6aa9d667823ef182f43831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b31c20a3a59730974b6be6b53fef21721b3143e08fa9790c5c8221cb6b55321"
    sha256 cellar: :any,                 x86_64_linux:  "dc92ace92ae0957403b3f0ea120685aed708509e72988161c5765adb56334f68"
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
