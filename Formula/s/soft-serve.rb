class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/releases/download/v0.11.6/soft-serve-0.11.6.tar.gz"
  sha256 "d986f988834615ea602194e35bdbba8ea9eb8948f9603475ce8c5acd4a8df9d6"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d66833542b98d14d3970a45fe85e55d6cc3cee5f924ae29afe877580e3057705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e47346041f811a823d1a21caee2564ba20cce6564b98fc92e3fc6e1d2c1b6d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "743cd8be41fafbb21bf558191f7fb67fc9a915e712c1301045d86dd5f0ea5777"
    sha256 cellar: :any_skip_relocation, sonoma:        "00b22a1ad09e68278a70be051fa0081a1a0e64d901c3bdb3a9d3a6ef030aa138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a85d06ec29af35f1a41750ca77475cc16d37d81a12c3113b0e61d4bd465bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e041b4d0dbd0adbd4f4b89217897f62b3cb7b9396de6b0718fe12ed56315485"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"soft"), "./cmd/soft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/soft --version")

    pid = spawn bin/"soft", "serve"
    sleep 1
    Process.kill("TERM", pid)
    assert_path_exists testpath/"data/soft-serve.db"
    assert_path_exists testpath/"data/hooks/update.sample"
  end
end
