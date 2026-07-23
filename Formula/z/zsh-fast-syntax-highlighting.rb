class ZshFastSyntaxHighlighting < Formula
  desc "Feature-rich syntax highlighting for Zsh"
  homepage "https://github.com/zdharma-continuum/fast-syntax-highlighting"
  url "https://github.com/zdharma-continuum/fast-syntax-highlighting/archive/refs/tags/v1.56.tar.gz"
  sha256 "9e5045510ef86beae658b5fcf58e7b6c76f5b63788498b956d54bc1038faa806"
  license "BSD-3-Clause"
  head "https://github.com/zdharma-continuum/fast-syntax-highlighting.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "548b80e35f30d83768a48dee91e0f3e39ef7a3b1af70d65560fd15a75a5218ba"
  end

  uses_from_macos "zsh" => [:build, :test]

  def install
    # build an `:all` bottle.
    inreplace %w[fast-highlight fast-theme test/parse.zsh test/to-parse.zsh],
              "/usr/local", HOMEBREW_PREFIX
    pkgshare.install Dir["*", ".fast-*"]
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
