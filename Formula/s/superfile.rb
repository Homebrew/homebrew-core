class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.dev/"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "7340ce9e3e7db401164310dd5d2d1dfa3ccf76118ac49d192b0fac2a292c5b0d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e059e191f05c424a06d45832dc64b3469318b3c06aa248000629331719b6fd2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efdf73d7503e3be273a4cdc75b10aeef88a1eaad01715b69664850b36b718d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0888a81971691aa4703a3d95ea744bd3c7de563185625dfa9a3a6bd267ffa2c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2821121a849d58ad865e57831b1f64d8870cbcd9e5888684ee0843d6e0d4776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff2eff80c3d977850561d71f921be083292525ce2525668ef2e9a19a0b8a382c"
    sha256 cellar: :any,                 x86_64_linux:  "585a99e50d632662aaa0ae9375640dea472e3d33814967b2d4475e623e4021bb"
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
