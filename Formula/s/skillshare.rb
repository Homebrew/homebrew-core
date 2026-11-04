class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "5428dab2ae509893289e48130323bc3a3a35f794163ae71f9509bccb05f91586"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28a04e73fe6eb28c5b4bdafe3d5913fd7c4bb8f42054f02771a8db4c43b4ed9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28a04e73fe6eb28c5b4bdafe3d5913fd7c4bb8f42054f02771a8db4c43b4ed9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28a04e73fe6eb28c5b4bdafe3d5913fd7c4bb8f42054f02771a8db4c43b4ed9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2553ef66cadb66d722842f223cba5579a70c4b5946dbde6d2b10189a52b80e51"
    sha256 cellar: :any,                 x86_64_linux:      "5cf0c59c07c7089612b7c125432cf73bddec19bbaa71e03772575826017c323c"
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
