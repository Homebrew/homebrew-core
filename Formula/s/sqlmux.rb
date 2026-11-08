class Sqlmux < Formula
  desc "Terminal database client with tmux-style panes and Vim keybindings"
  homepage "https://github.com/kackerx/sqlmux"
  url "https://github.com/kackerx/sqlmux/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "74f208da4ead458842a8e49275666cebf14bf727f5fad63394e4e6b65f927a7b"
  license "MIT"
  head "https://github.com/kackerx/sqlmux.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8650c702f43df9af9b41a2ca046cdf295b064d102544f9bf18df66cb97e8dbfb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8650c702f43df9af9b41a2ca046cdf295b064d102544f9bf18df66cb97e8dbfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8650c702f43df9af9b41a2ca046cdf295b064d102544f9bf18df66cb97e8dbfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b43fac0aeaedba798a9c5f600b61e163ce1da18ed4c20298fd5c71ea039111c9"
    sha256 cellar: :any,                 x86_64_linux:      "fcf87187f0f7853bcd97f907d63ea39cde05b7923a7c3f87c1bde7c31a36bba3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/sqlmux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlmux --version")

    output = shell_output("#{bin}/sqlmux --where 'id = 1' 2>&1", 1)
    assert_match "--where needs --table", output
  end
end
