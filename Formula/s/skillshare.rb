class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ffa01c8110be9000fc2e19ad6d9c8134039659cb41bded3eb9ae404975227e17"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e119dfaaee857649d40d94d887f6d27c5740bbfe593e6271409ac684c95c13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e119dfaaee857649d40d94d887f6d27c5740bbfe593e6271409ac684c95c13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22e119dfaaee857649d40d94d887f6d27c5740bbfe593e6271409ac684c95c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e1e16286454fdf70bad255ec3206fa587be98a03c901d4c2e547a395537e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b782a4069c98a821c3af4cea5dbba701b1034244151e7ae03827b9fb54516846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f588dfd43709ac450718ce66748c0912c541e18100986877e0ede243dabc2e2b"
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
