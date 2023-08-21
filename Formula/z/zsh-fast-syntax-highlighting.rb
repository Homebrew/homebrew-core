class ZshFastSyntaxHighlighting < Formula
  desc "Feature-rich syntax highlighting for Zsh"
  homepage "https://github.com/zdharma-continuum/fast-syntax-highlighting"
  url "https://github.com/zdharma-continuum/fast-syntax-highlighting/archive/refs/tags/v1.55.tar.gz"
  sha256 "d06cea9c047ce46ad09ffd01a8489a849fc65b8b6310bd08f8bcec9d6f81a898"
  license "BSD-3-Clause"
  head "https://github.com/zdharma-continuum/fast-syntax-highlighting.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5491428e00739fd9a4f66c979e2a1cd132b42279c2088052e071797a88fb9f28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5491428e00739fd9a4f66c979e2a1cd132b42279c2088052e071797a88fb9f28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5491428e00739fd9a4f66c979e2a1cd132b42279c2088052e071797a88fb9f28"
    sha256 cellar: :any_skip_relocation, ventura:        "196df85afadfaeac5121915b914bab28a77e6fdbf6d4bb3e5d0fc6f7e8c4dbbb"
    sha256 cellar: :any_skip_relocation, monterey:       "196df85afadfaeac5121915b914bab28a77e6fdbf6d4bb3e5d0fc6f7e8c4dbbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "196df85afadfaeac5121915b914bab28a77e6fdbf6d4bb3e5d0fc6f7e8c4dbbb"
    sha256 cellar: :any_skip_relocation, catalina:       "196df85afadfaeac5121915b914bab28a77e6fdbf6d4bb3e5d0fc6f7e8c4dbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5491428e00739fd9a4f66c979e2a1cd132b42279c2088052e071797a88fb9f28"
  end

  uses_from_macos "zsh" => [:build, :test]

  def install
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate the syntax highlighting, add the following at the end of your .zshrc:
        source #{opt_pkgshare}/fast-syntax-highlighting.plugin.zsh
    EOS
  end

  test do
    test_script = testpath/"script.zsh"
    test_script.write <<~ZSH
      #!/usr/bin/env zsh
      source #{pkgshare}/fast-syntax-highlighting.plugin.zsh
      printf '%s' ${FAST_HIGHLIGHT_STYLES+yes}
    ZSH
    assert_match "yes", shell_output("zsh #{test_script}")
  end
end
