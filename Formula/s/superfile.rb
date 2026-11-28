class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.dev/"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "cdca43cebee4b302104274084d67de31e244b4add39a247a76ab2ae3b255e7d6"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "5ded033f33f6e619d1868b6b87d90d64fb68f67cb5acf700ba01941b92d82773"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a02936ea1b3a238114e51669b20df6d2296cdb3413127f38cd319d3a853db4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ac6b9039dd9dd4775e061fc75f002d4bf1811f0bfe702ae7cc89b4291896a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a39ac00b7c541b5fa21d4cdaebf73014e1733d8948bc12355f794c2cde361747"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b71ce06b8ac29d06afb1a92558375426a8e67dd539f7300b91f97775858caa3c"
    sha256 cellar: :any,                 x86_64_linux:      "7588cf5d0a88d5a047f328c5ce8ae1a5f5b0041d4792276127e9bf195ec65b75"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
