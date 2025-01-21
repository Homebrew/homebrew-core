class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  # site cert issue, https://github.com/spaceship-prompt/spaceship-prompt/issues/1431
  # homepage "https://spaceship-prompt.sh"
  homepage "https://github.com/spaceship-prompt/spaceship-prompt"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.17.0.tar.gz"
  sha256 "cbc5aae5bea9e220cba10c1d12f9fccd9899ced94ea443ac16fe2df72a22b1c0"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce5c6bec01e880dd3976e7b0608607c37960853bf99e839e7d56f964cbc227e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79cd096305e96362b25b6aec861ca76c75d0ce126b6cdf4f1b15a7aaf1cb8b8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8af1ac116903405892b6cb1227f7a80c996d6863a0729749538b4da3bf296a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d17bd547af57f2e106d39eb9b1ec5e60e52680832a422a9802077bc1cd8da3a"
    sha256 cellar: :any_skip_relocation, ventura:       "dd52537c22b8f91961fc06d1e3d67a01d9576702aeb4b52e24c91dce82c08519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50e5beccf69107375834c8121fd8220b5a67af875aec6b57d23a0e4b3782d64"
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
