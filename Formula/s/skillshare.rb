class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "6d3d221a32b62bd945c40854784d3d67f695be8b6b865961d0115cb9e90f2017"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    manifest_sha256 "67420554d94669354a6bbfe6ec1869a7abe294307a6673051966e3c4e53a9186"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "efb6e9a31f195e5c8e31b36bcf4a17118556a9f9ee3d1c2f21763c671ab9b389"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efb6e9a31f195e5c8e31b36bcf4a17118556a9f9ee3d1c2f21763c671ab9b389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efb6e9a31f195e5c8e31b36bcf4a17118556a9f9ee3d1c2f21763c671ab9b389"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "562d3d09ea430b54316e81d92f4cf8470fa59042f754732f8ef80fba78637f79"
    sha256 cellar: :any,                 x86_64_linux:      "f53f8f2b31724cb9e8d8773a366a08f4360f54bd2ac16743b3e68eb877097d7b"
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
