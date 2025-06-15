class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "4ca1f83301db00bffca583b116e31f892954333f1f539800a0803c141c68198c"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a53d435a0d34b78869b95185ab81b3366defcbce07e6a25358122b6322c47b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a53d435a0d34b78869b95185ab81b3366defcbce07e6a25358122b6322c47b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a53d435a0d34b78869b95185ab81b3366defcbce07e6a25358122b6322c47b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "06ff52c7eb50fd4acbada6a5e8b42a5b9c201143d56cb47264977b2f351f1d00"
    sha256 cellar: :any_skip_relocation, ventura:       "06ff52c7eb50fd4acbada6a5e8b42a5b9c201143d56cb47264977b2f351f1d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "571960d6e2bff838c0e4f639a11ed0c9cc47c3e1e5e150827e88fa97b0ae4eea"
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
    lint_cmd = "#{bin}/xk6 new github.com/grafana/xk6-testing && cd xk6-testing && #{bin}/xk6 lint"
    lint_output = shell_output("bash -c \"#{lint_cmd}\"")
    assert_match "✔ security", lint_output
    assert_match "✔ vulnerability", lint_output
  end
end
