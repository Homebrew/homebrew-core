class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.17.5.tar.gz"
  sha256 "fd73721b2962dbd024d295a9cf1c86ebf775292fffe1dec5235e15469297adeb"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94e9eb5b4108cac4aa4f97f84b4267d3aa0528315769b34d3c241fcdef480992"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94e9eb5b4108cac4aa4f97f84b4267d3aa0528315769b34d3c241fcdef480992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e9eb5b4108cac4aa4f97f84b4267d3aa0528315769b34d3c241fcdef480992"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7ee0d733af5818601524b025c8702ef27578f2c960b7f9bec7399a8d7ccaddd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c7309cccd8f040e2154aaf0e5e32f2db9a97957d260ec1c147f0b2049c55069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acbccf9b47fe451726e024d1a5758ab9c8d1361205caa1f383f2e9ebf2891262"
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
