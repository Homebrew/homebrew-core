class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "5428dab2ae509893289e48130323bc3a3a35f794163ae71f9509bccb05f91586"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f545a70eba883caedc3423363b45c75f72436f71ed62a2ca1db497d6899fc452"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f545a70eba883caedc3423363b45c75f72436f71ed62a2ca1db497d6899fc452"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f545a70eba883caedc3423363b45c75f72436f71ed62a2ca1db497d6899fc452"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bc258029d29881edd52896c479b1377e462128423f5e425cca885b44357ce1e2"
    sha256 cellar: :any,                 x86_64_linux:      "319c916af6ec9ef09e246429355c0d37a054580402f26cc3e1f80a1eb33fa0e5"
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
