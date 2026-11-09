class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "3267a881a3cf15dc7052d446ec305daaac74f75136791e050ab37241613531d9"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd06bffd54aa574ca6dc37e897737d6f1847d7cb5aad1c351ce23801d58dd8d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd06bffd54aa574ca6dc37e897737d6f1847d7cb5aad1c351ce23801d58dd8d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd06bffd54aa574ca6dc37e897737d6f1847d7cb5aad1c351ce23801d58dd8d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "01d5f78a380fc5717671563b66e8e30e33662cc200476b5e28235ac291f641cd"
    sha256 cellar: :any,                 x86_64_linux:      "042c8574e89d37ae58b9ad80b371089547417d125daf16773c8957c352257e63"
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
