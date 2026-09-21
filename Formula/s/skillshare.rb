class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "aa9dcf4f0a86b25aa9c127ec41896f64dd896efa6a4d347741b5710711f5fc6e"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f51f863aaf8ed5f0efd46bade5f112fce52bbe6937d173bfadd1e4df023fbc16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f51f863aaf8ed5f0efd46bade5f112fce52bbe6937d173bfadd1e4df023fbc16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f51f863aaf8ed5f0efd46bade5f112fce52bbe6937d173bfadd1e4df023fbc16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91a6580d1e3d029f5edc55671788873c408649ccf6ebcb8a9ace1ba7c9fc232e"
    sha256 cellar: :any,                 x86_64_linux:      "6085b3380eda9f446f2e44e0b4b3043eb9a4413adc22fb5bb722f81154b0556e"
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
