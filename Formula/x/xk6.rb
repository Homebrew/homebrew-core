class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "d9fe9610daf066ba988363b8a8d8b6b1769c8b1ffb60ce7de25706214390f7a1"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467be00d5f211ebf138622120f0bdab05d6356a531c09a143c24fda0d70aee13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "467be00d5f211ebf138622120f0bdab05d6356a531c09a143c24fda0d70aee13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "467be00d5f211ebf138622120f0bdab05d6356a531c09a143c24fda0d70aee13"
    sha256 cellar: :any_skip_relocation, sonoma:        "78ff3d0ccccb5d6db199d65c9607b9c2500e3b626d756754c73502c7feb8aef7"
    sha256 cellar: :any_skip_relocation, ventura:       "78ff3d0ccccb5d6db199d65c9607b9c2500e3b626d756754c73502c7feb8aef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615f0eab444cc0e1e7eed6f0ef8f1f2250ddeeba8882bd9999b01859a470204d"
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
