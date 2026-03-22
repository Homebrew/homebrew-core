class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.17.9.tar.gz"
  sha256 "ebfc5bfcb4df03e32a02b1aba2ccd41a46ec30f29cf0b583aca8495c002db56f"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6a92ff854b2667d73e1e2a4dbbb4faceb6b962ee14689f496c01456b534b0bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6a92ff854b2667d73e1e2a4dbbb4faceb6b962ee14689f496c01456b534b0bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6a92ff854b2667d73e1e2a4dbbb4faceb6b962ee14689f496c01456b534b0bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "835d36b03e8eac2c85c008a3548726b158371671b0ba2feaa2760d0cecfee128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38bc994a224987f6ce898df0a709e1a6a7a124c219093587efef483a58f7e2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b9e31488fd2244774db5ead783a20fee50a44da84f2ec052d7cfd6f04b917c2"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
