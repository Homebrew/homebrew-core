class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  # site cert issue, https://github.com/spaceship-prompt/spaceship-prompt/issues/1431
  # homepage "https://spaceship-prompt.sh"
  homepage "https://github.com/spaceship-prompt/spaceship-prompt"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.16.0.tar.gz"
  sha256 "267d31609d4a34ac61bbe8655af7c8de74a51bd77d651114666866479621425f"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5fdeae08d82ab3dbd4aa6933f2ce1a9b2c69f676512caa3f76af787b9df11c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73d0d9df9d9c9796736aa258d65a2829acd3399689d4605d5172e75491a824a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e673a0592a474734d1e6b6538e27e867d8b2e19bfb6313b6442bc75486ddb94"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2c809b5e80bb545427997f4ec1d1556af98bc79f34ce6bc32eb8f90901739e3"
    sha256 cellar: :any_skip_relocation, ventura:        "5b3b7302e26dd2b7a410df486108c9aa6dd51c1e97438cc3415ebb30a4cfa3a0"
    sha256 cellar: :any_skip_relocation, monterey:       "b025e21ffdc41930410f2b1aa5b70da0860c2b07d3fed77abeee3228af5c787c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1993ef465acb6d09c12b256fae568c02d3b845837530da893161f297df398a3"
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
