class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "06ccc19a36f7a4d28ae48d509bcd0c0509db92fadb93061366a8612b54d91c98"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b54203055be8230ee493f379ffa9511603a0d6b5cf1d0b13308da533da52bba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b54203055be8230ee493f379ffa9511603a0d6b5cf1d0b13308da533da52bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b54203055be8230ee493f379ffa9511603a0d6b5cf1d0b13308da533da52bba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b54203055be8230ee493f379ffa9511603a0d6b5cf1d0b13308da533da52bba"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeea081d6761dcb9639bc2a7458543b4738d2f8f014e415fae520b649fce5aaf"
    sha256 cellar: :any_skip_relocation, ventura:       "eeea081d6761dcb9639bc2a7458543b4738d2f8f014e415fae520b649fce5aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "151ddeaabd723c66ad304431ca7bc35140a69ae816f50ca3919b117d2ad76c7b"
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
