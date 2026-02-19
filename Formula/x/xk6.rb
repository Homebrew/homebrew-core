class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "94b223374c7a6540d83671823f6d85d1cd5857a95c14a53fc3c2190fc425f309"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89f75c7373bbaa2b11057c6a9770939f70f67ff92ba1088dc5661235912b9a6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89f75c7373bbaa2b11057c6a9770939f70f67ff92ba1088dc5661235912b9a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89f75c7373bbaa2b11057c6a9770939f70f67ff92ba1088dc5661235912b9a6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85e165918d40724faa5e4eeb251d81c40c59e0783b914f410499667dc0a4859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28b78d10f51fd694097d3f621cf588969e56880a6c8b9cddee1b77e0d5e30cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59058f81e2ddc2c3feaaffaecf21f2bebcaca954c07f8b4ed66a7eb85d7ece0c"
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
