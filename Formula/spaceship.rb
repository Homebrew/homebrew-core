class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.6.0.tar.gz"
  sha256 "30e67f867262606db5d7f9a108b62a75a360e202074337f122ca6459368e5668"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999179e2c1f4547771067f455e6fed28d8c9368dc1e0336328d21b12a706dd1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3499785834d2959b0dd8670c3018b03b4819a71d98180eb4872cffebcced2535"
    sha256 cellar: :any_skip_relocation, monterey:       "4cbb1885e33e7a05115c13af6cde4e0fe434b5c72c407bb5a9d3b6c7132f4c22"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc9526edcabd4a5779d615a909d6db58620201465cb3a30e38ef270c10dfb542"
    sha256 cellar: :any_skip_relocation, catalina:       "3174da1e42e5df18f5bd8d4ee6e7064fd69994ae01bd74397fdf57d1dbe4e716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1dc6f68997b1df457941dc986478f4c36879e81b8e5a68e68400fe97cb16bc3"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end
