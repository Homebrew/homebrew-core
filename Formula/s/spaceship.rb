class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.15.0.tar.gz"
  sha256 "7fcac06c846269ebc3c7e01fb8e3ba4c9605788ddcd8f6dd2dbabea1efa84391"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7aaf9b85404f9dde679da4969ce895f8da6c59382c0b6e822b4e86c7f2d3459b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5647a128ce8a9a4fc4e92b4642af9de39557427c81a9fc972782e44f6ac0da77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d94ce944e5e324e2682f71e0b15b92156299d88da45d0ec9da5c12a5ac8b4fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "388c50848c16e3436381a27a51c6af2b4f33994eeee53a16593aa4ec63412903"
    sha256 cellar: :any_skip_relocation, ventura:        "ad77781146cc66653d4fd5544bc03dbcd84850d13cbb4ca6b83da3783ae6fee0"
    sha256 cellar: :any_skip_relocation, monterey:       "eaabf101e6a111971dc807c28de3afaf59af7a2cd79c04744a5833e8ac0d5577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c01b96877cb656f1bd6828606eb10d6f3e887a020103597aac651577e8ac686"
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
