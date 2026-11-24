class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "4c709ad5fef4244b518725365ee6d0e294117d8b7a4d3f201c4b1499a691d1a8"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    manifest_sha256 "339094428038b3fa92458cf827f71ee8a00dae26e45cee6c99201b38aaeda7a7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "353b00592da1c917e847833fab72bca4c4b949f36e551aaf657c4dc4ec2e7018"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "353b00592da1c917e847833fab72bca4c4b949f36e551aaf657c4dc4ec2e7018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "353b00592da1c917e847833fab72bca4c4b949f36e551aaf657c4dc4ec2e7018"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "466f9f04c098a9b95b988310a1a1144bdfedde1763bb4d9c010b5f09a7f65ac5"
    sha256 cellar: :any,                 x86_64_linux:      "21462a6ce398f8f0e3b08db7eb3d7855d6b92fc3625d64df8a18ff543ba99ba6"
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
