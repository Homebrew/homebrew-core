class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "dbd90b0edbf972078fe5daac06082b554ce7578763462d8ec1056bddba4f2ca1"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2869daea3aada9e05e7f91a7e7fa6c710d65ba017e3ab60b0a7d59658d8f070"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2869daea3aada9e05e7f91a7e7fa6c710d65ba017e3ab60b0a7d59658d8f070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2869daea3aada9e05e7f91a7e7fa6c710d65ba017e3ab60b0a7d59658d8f070"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "90ebd069409cd0d96a38c2557d2f2ae2b721df9c67da56108783048fd3cb1422"
    sha256 cellar: :any,                 x86_64_linux:      "615b0ad65f20ad68bb9f74346097e27de23b5a44e966e97123400270122f1fbb"
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
