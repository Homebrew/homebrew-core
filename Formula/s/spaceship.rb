class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.18.0.tar.gz"
  sha256 "61d1745ca966430342cc397c168979a7b3605228837cde63e73891c1e4567311"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f19f97eaa9c8a1e6023c70d60caef2c68a30c835c9e86ebec8e523df0cf68f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39af573470a2ccbe82580979ac02176c605739a28b00b54b423add82340f1551"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bccca808d0e02634751dfda4f73c2b7f9e7a4c2d178780db7116266e663c285"
    sha256 cellar: :any_skip_relocation, sonoma:        "29cb24daf6005013d04686775eb6179387d002aea7fba66c737396a71765c2d5"
    sha256 cellar: :any_skip_relocation, ventura:       "74d1cd64f2e89c1749dc9e1070f3ce1e9f3255680c47cf6be6b9fce214db3023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9fbe1ccc3718a6fe03aafbc047b0d087676dadafe47f46cc79679d66caa574a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2eaba4f3e4ee2ed2a19165ca43246332f0c4bb70453e0a8063da10210c1feb"
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
