class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "be163687ec9bb861be157147572c3161288e30cbfbe1fb9e334b76c2fd7ca202"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecdc1068979d4478fcc64fb30fb78ab853d6661353ed47db06f74de56b37ae72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecdc1068979d4478fcc64fb30fb78ab853d6661353ed47db06f74de56b37ae72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecdc1068979d4478fcc64fb30fb78ab853d6661353ed47db06f74de56b37ae72"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fd7538f26bb72d210bf089db639dc16b564425786d0008d1010ae057e37d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cca504a60017f28330387ab93005f3487e1635ae29671af4d731a37bdb2b5b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58a0cd834bc472dc6bd9e4ffe14ce7fdbd50cd80e38ac59cf57c4b33ed8a8dc3"
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

      lint_output = shell_output("#{bin}/xk6 lint")
      assert_match "✔ security", lint_output
      assert_match "✔ vulnerability", lint_output
    end
  end
end
