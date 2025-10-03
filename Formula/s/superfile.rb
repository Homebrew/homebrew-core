class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.netlify.app/"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "f50f4e9c56dff67d3682216950db164fc6caaa1418049c59b42bf5e65d31d04f"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18cf8fddb3c3ce306f084073086275c96fa08378911f77a9fbfb916f69abee41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2effb87953c80ab50e0ab351599c4d9c1f3c89300a1451f8113bb4152d025567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b823bdd45f7c323030ce9c81fa718443128388012bcbe5f1ba63f7b4f874f6cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "851d247dd23aa52231ea96cc9540811df8e410d205df8971f8cc4064a3f90ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d0a12f90d183d1790101dd58b524550046b93a46e334d87a2dac2611447d4ab"
    sha256 cellar: :any_skip_relocation, ventura:       "f0d0a9b2f4ea1cedc0a54e58eb5b09942d4ca5ad6bf56e7144afe08597791b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49271ebc391f9d5ea927c28f45cebb7ab8378d31952fd6fd2743c04b935ef828"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
