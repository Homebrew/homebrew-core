class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.13.tar.gz"
  sha256 "92c886a4a5988132b234c2099cdb5f224b3230287ff723650e3c788a4428ccdb"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70c3e57f2016a0ed10743107b6e01649349b640eec54797f8b77b121a6be7b4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90e658923ce01fb94aff4903f9bb47cacb5bc43a95008f667bd4c7ed6af1efde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9de0c26381186a2a464ca481f06ccc42238d11fc00081cad51d0fb1cc6f93fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d252859e393ee717371e2a213af25a53dce7117fadc02e2c034c95c905297a3f"
    sha256 cellar: :any,                 x86_64_linux:      "544fb291d1a2b84077b6aae619af37ddcb4468f719604639e08747cc952db32a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
