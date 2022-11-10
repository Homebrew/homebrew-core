class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.10.0.tar.gz"
  sha256 "b96d77ccdc879bf718e9e612611ac82a499ada898e769cca3d47c48acbf56018"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f6bfba277f75ea2684896f6c431f2158a8ffebc12504236807535a17d95bdf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b0c109818f813aca0fa67bdbadc2431ec0c2837a518c2343cf805c24653ead3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdcb343de0c3b84792adf52609c2a1575c52751508ac9d050560b84c6851a293"
    sha256 cellar: :any_skip_relocation, monterey:       "410a8b450fdf1aea35a25c84c29079d6214437056c654e7656f6e667723580dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9d7a045f5483c315cd136d39b6aca008b3d356838dbfca6d18d40cc4f0e7bea"
    sha256 cellar: :any_skip_relocation, catalina:       "eb29c5671e3edcf59aba5c0e34f5e5fe0087f7ffe64d3085bea02301c81040b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a58d6a5cd4c1a678a7f9e15370676a08cc97665df334f16dc150d2bf606b0d7"
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
