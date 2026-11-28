class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "2784e958e9ce7df8158f0eec26985fe1451bb3ae5add029be02621e761e18d4d"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    manifest_sha256 "e8934d4cb735e0eb83b410eb66c1e42bd5d1dd00f84e4dea91a6b3fb9766ca1d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0982a3db1ed75e724b6a4fb2b83624a16c9dc98d51037b0a307c86a6e5ca9e24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0982a3db1ed75e724b6a4fb2b83624a16c9dc98d51037b0a307c86a6e5ca9e24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0982a3db1ed75e724b6a4fb2b83624a16c9dc98d51037b0a307c86a6e5ca9e24"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a01d3b9e114333cebf3687e64933b3a3bd111647701fd90a164e0cd8c2fc9ec5"
    sha256 cellar: :any,                 x86_64_linux:      "31d9cae2aefcf04680d5a9f9520d1dd94a304fc84ae1109df7d77ac94c9abfc5"
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
