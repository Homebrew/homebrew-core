class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.4.tar.gz"
  sha256 "4b54c751fcd47e08eb8e81a6f2a534db61a3d51f261f8a28dc89117795cf1aeb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34062a0589b251a622ebb9fd2f9ec76b5b40a5f76dfc07b708cfce5fb1cc3e98"
    sha256 cellar: :any_skip_relocation, big_sur:       "dadd5583361bfb3610ad23377330dbfdc927c8ec03628d6d01e02b1fd19fee78"
    sha256 cellar: :any_skip_relocation, catalina:      "e9842beaa2e390b267b3591f71f0bfad7e6489e3c098b64d0e3c80da26b4b0f1"
    sha256 cellar: :any_skip_relocation, mojave:        "252d7e4721aaf564269ed76953ccd5f60c07c0841ca357d3884140fa74ea4fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9adb52590e18569178f4238a312a74d2177fbe92956820dd6a5c8b5e709506"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
