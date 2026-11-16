class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.9.tar.gz"
  sha256 "37ba462e69b7b3f28a61faa5f60746bc847961d7b900de79a50873bd33923ed2"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61422a4b049e2578c225df539ab89d3472e5c6e43d5c71e528714668966f6672"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61422a4b049e2578c225df539ab89d3472e5c6e43d5c71e528714668966f6672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61422a4b049e2578c225df539ab89d3472e5c6e43d5c71e528714668966f6672"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63301c168956ed263d54a755cd052b9bc038b241e268b618ade00cc29d6f4770"
    sha256 cellar: :any,                 x86_64_linux:      "5a0d86567a0c2b205d24e6dcc8ad7bf90d91e3eb3b8105f775bc32dd29c6bd31"
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
