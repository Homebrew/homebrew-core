class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.5.tar.gz"
  sha256 "2b82500b06efd7bca5c5a104279d247ec24466f90f38df0e65cbfa4509e67fe9"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a646af652df5cc0f9b0a727a7b8ce00f315116171ae399f376b8892438676d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a646af652df5cc0f9b0a727a7b8ce00f315116171ae399f376b8892438676d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11b7507cb3342fee0734cf0f74e8cafb8184d31a5d025c794ab47d22cf045c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab63848954d69c9a5692aaa49971e00fa6ef9b9cf546c577088f74acee1fff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78271d687c2539835dd5cecb577c56430fe099337261598d1d58b36926cbcf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78271d687c2539835dd5cecb577c56430fe099337261598d1d58b36926cbcf7e"
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
