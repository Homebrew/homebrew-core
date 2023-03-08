class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.13.3.tar.gz"
  sha256 "8e39135f338e269a15b0c1610964377923077de77e02f50f5be31e9b753233e2"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f86c510af6810876f9fcaa6084110c8a140a2251519eb4cd4cefc39fe9066c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a02268d8bde3f0d1d1c558732e5497a79da0e232ed25ae33b10d354612b71717"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d734d08107d51a39aa2e5f9618deccbe4f06aa271ad8f83e2341ab6a3cb02eb"
    sha256 cellar: :any_skip_relocation, ventura:        "593896dbe6230cc0730f22afdd6ca405a57779e93e14aa3f279a24cb64708c7c"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea963105ee5cb6f238445dc92e27a1982dfca3026a1e7e9eb11b403bf9386f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "123fba9ac703e55a458a7c9781edf15fd9a5af1822ee6158a3d983031b4f6293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e77580b89abd564d1fda092feb99a01b510869947b8aadbb2df3c539f5aa96da"
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
