class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ec027726aa6859a138402d76ae4270a54eaec76f76fb4c3c44a3c83111957339"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1eecb5511419280ba899da5f2976d96ee39504320724e76807a6ae6ff456d35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1eecb5511419280ba899da5f2976d96ee39504320724e76807a6ae6ff456d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1eecb5511419280ba899da5f2976d96ee39504320724e76807a6ae6ff456d35"
    sha256 cellar: :any_skip_relocation, sonoma:        "d99c8b685fbdecbe937bb960a9248491fbf956ace5295bc0b4f60cfcaa8003c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13a7dd8697d7c3ee3c9f0a01de68de6ec91c1384b2ffaaa908243ba11967a9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab0952d0585775ff76737e89d1d6db07369ac11e9bb8d8c0218c606ea27c13c"
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
