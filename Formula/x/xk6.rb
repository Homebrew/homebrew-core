class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/releases/download/v1.4.11/xk6_1.4.11_source.tar.gz"
  sha256 "f2cbc51317272aaa6bbabc4e8003f334af41f007af3276c81c60f3079130d719"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b9633006a7ea57de327c53ae7b60caf60422f563620e40603f2927e61d329cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b9633006a7ea57de327c53ae7b60caf60422f563620e40603f2927e61d329cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b9633006a7ea57de327c53ae7b60caf60422f563620e40603f2927e61d329cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed91f5035dde369b3b5671a6f3f992df6026d6070af6fa8600a5937c06e9ff04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3dd7740ce5a16698a98d767b5d3a7d1209c5e34891f9232b7936b96211274e"
    sha256 cellar: :any,                 x86_64_linux:  "542b04437927f271fc6819e7a42992520181c3a67891d67437034282605bcd98"
  end

  depends_on "go"
  depends_on "gosec"
  depends_on "govulncheck"

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
