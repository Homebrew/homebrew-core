class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "135aa76d884cffa6acd1605bf13d9dd14d5557fc5988921ac23bd414aebbb290"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8bb1fa4e819771dd3f9f0ea20c74e6d7bcc97a00cb2812df59024cc8e4571e5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8bb1fa4e819771dd3f9f0ea20c74e6d7bcc97a00cb2812df59024cc8e4571e5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bb1fa4e819771dd3f9f0ea20c74e6d7bcc97a00cb2812df59024cc8e4571e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8864eed5d12e4c696cd71fd3e369dd5ec52442c6d9aaa8f3f96e302f58e93d69"
    sha256 cellar: :any,                 x86_64_linux:      "c55e1fdb5ed2136e69a11ecb3b72ce221ff25ff444a4b66950bd8a881658fbb9"
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
