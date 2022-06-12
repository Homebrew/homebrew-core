class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.7.tar.gz"
  sha256 "664746d50fec283e16185c3463acdec04a987d65ccee75d4a0a5d3c08c50e708"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485be540780023ea9c8f56a6fcd404b25b99780bdab29564213e6c7da94fc82e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "982668f18d7d220a7347e4ccbd252a58597e74d3db758025bdecaa3b04e1a519"
    sha256 cellar: :any_skip_relocation, monterey:       "6724f94a07a7876391ba8d1683bd667b6ede3243864fd5faa95ac2138ac488fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b43cc27fd91e47ed150fa5e957e4766baf7047b4e4f21be68f5f7c98c895110"
    sha256 cellar: :any_skip_relocation, catalina:       "904cc3f067576f6bc2c174662be1b83ffaa52319a574148879e927016a33112b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbfdb71eb9af9c4146decd6ad8e8dd822d8d4cd1142f517de9909f411be15f94"
  end

  # Segfaults on Go 1.18 - try test it again when updating this formula.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}")
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end
