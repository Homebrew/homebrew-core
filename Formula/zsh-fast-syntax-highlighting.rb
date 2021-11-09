class ZshFastSyntaxHighlighting < Formula
  desc "Feature-rich syntax highlighting for Zsh"
  homepage "https://github.com/zdharma-continuum/fast-syntax-highlighting"
  url "https://github.com/zdharma-continuum/fast-syntax-highlighting/archive/refs/tags/v1.55.tar.gz"
  sha256 "d06cea9c047ce46ad09ffd01a8489a849fc65b8b6310bd08f8bcec9d6f81a898"
  license "BSD-3-Clause"
  head "https://github.com/zdharma-continuum/fast-syntax-highlighting.git", branch: "master"

  uses_from_macos "zsh" => [:build, :test]

  def install
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate the syntax highlighting, add the following at the end of your .zshrc:
        source #{HOMEBREW_PREFIX}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    EOS
  end

  test do
    test_script = \
      "zsh -c 'source #{pkgshare}/fast-syntax-highlighting.plugin.zsh" \
      " && echo ${FAST_HIGHLIGHT_STYLES+yes}'"
    assert_match "yes\n", shell_output(test_script)
  end
end
