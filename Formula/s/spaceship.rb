class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  # site cert issue, https://github.com/spaceship-prompt/spaceship-prompt/issues/1431
  # homepage "https://spaceship-prompt.sh"
  homepage "https://github.com/spaceship-prompt/spaceship-prompt"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.16.2.tar.gz"
  sha256 "8892708e4c6c6a0ddff8dbe433e8384606d9a6b73b2cab48ac5ef80adc1a018a"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb5665cb4cfed8f23122e2eac1ca73e778154fb54f960b3842ff025f05700b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f6e0071cffbfe42f213775718d2e36e983cad93650ca50983f55615971bae89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a182a6d3c1ccbdfab3851cc27630e8969496257e4795d83853d54355ba833cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d68bfe382f70f476391acfa3a73925a76f79e94695a7ffeb46ac190c0daad23"
    sha256 cellar: :any_skip_relocation, ventura:       "73cdfa1d1f6b3f357d46b105b6e391913dcb6b47bf7408570e207a154ed12f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a26efe9322c2016fc56d433668eec2aa937aac0d2c61467cb6b8a0c4ef0b3117"
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
