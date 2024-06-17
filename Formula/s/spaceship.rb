class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  # site cert issue, https://github.com/spaceship-prompt/spaceship-prompt/issues/1431
  # homepage "https://spaceship-prompt.sh"
  homepage "https://github.com/spaceship-prompt/spaceship-prompt"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.15.3.tar.gz"
  sha256 "e4ecde51931ad85f9fa32716b5ff86ecbee8459ed3b6e12c2796708db60f7733"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "694e642ac29b8452b7b8f67f7ef771be78d09ddd19eed2c363dacd949013656e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f38bc23dda86e4f33d2d4b48cd475d4aef671ce5269e71fcd9b3bfc2227cc35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "314c15060c35fc682a390fb3854ce73d56382f574c592a677406e81719499196"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a7061a46c37540026fb5349f5f6921fbfe74d951c64c9b78d70654ec16d5f09"
    sha256 cellar: :any_skip_relocation, ventura:        "9a53de0a719400c46b3a4de91e8d60f443407b5b29c8ccdf0aaba23dcb73c6e5"
    sha256 cellar: :any_skip_relocation, monterey:       "513805c1d7bbb857d01c66e45384e8276deedf382c4957909fe556c765168d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be2be5f399f01a6e71a86f3a4adf0185b56af22d7ae7cf5b475b3c2bae124fc3"
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
