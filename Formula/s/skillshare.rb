class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "dc4d7d5110c478da3f74513d7e196ec8f13349b8205ca05d7a1c161c890b2000"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd573ae1ea86a69ac2a8955b86798a6d0a3b6f70217baa1d5d80b7ec695b0477"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd573ae1ea86a69ac2a8955b86798a6d0a3b6f70217baa1d5d80b7ec695b0477"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd573ae1ea86a69ac2a8955b86798a6d0a3b6f70217baa1d5d80b7ec695b0477"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47c4aea363d7b3ca7208e817a803a797fafff2d397f35e6dcb6a5082f36f9780"
    sha256 cellar: :any,                 x86_64_linux:      "4513379830c1b6f86ddbcf2dae5f6b34c8f7bf9c2521c6c679f2bdbcbc31cc59"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
