class ZshFastSyntaxHighlighting < Formula
  desc "Feature-rich syntax highlighting for Zsh"
  homepage "https://github.com/zdharma-continuum/fast-syntax-highlighting"
  url "https://github.com/zdharma-continuum/fast-syntax-highlighting/archive/refs/tags/v1.55.tar.gz"
  sha256 "d06cea9c047ce46ad09ffd01a8489a849fc65b8b6310bd08f8bcec9d6f81a898"
  license "BSD-3-Clause"
  head "https://github.com/zdharma-continuum/fast-syntax-highlighting.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b63cd29b30d65b5f15e12a53ecf2b8f78b8eae1e0a32ac5761d88933cb00ad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b63cd29b30d65b5f15e12a53ecf2b8f78b8eae1e0a32ac5761d88933cb00ad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b63cd29b30d65b5f15e12a53ecf2b8f78b8eae1e0a32ac5761d88933cb00ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0435113e89b05900636a678cb33a9e0d44382a005da60cc072ec944a613d2e"
    sha256 cellar: :any_skip_relocation, ventura:       "5b0435113e89b05900636a678cb33a9e0d44382a005da60cc072ec944a613d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b63cd29b30d65b5f15e12a53ecf2b8f78b8eae1e0a32ac5761d88933cb00ad8"
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
