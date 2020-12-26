class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/c0/fc/bd550621494f98a2d8ca4af3a18db4df1ba5961b06baa6ebe1bd1aab6f4b/youtube_dl-2020.12.26.tar.gz"
  sha256 "c937430888669a90315f11fa3754961aa4b472c6e217950c64141ec112090db7"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "17a5a938dec6d6f719e76ba3e4e060a7182a34e83269ded02ea46780ffb6882a" => :big_sur
    sha256 "25a55dfcd3c845982c34affe49c5b070f98ebd3e79f83c3500ecdb1273ae10ed" => :arm64_big_sur
    sha256 "5734e0e1f5e43cc7db9cf63f7d079a2212e024ed4652cc3ca89d8a2abeaa7fe5" => :catalina
    sha256 "f6f15c2acba96cba668a737c4b2a7bc770ed767a516059f1376f64e26d0b4d08" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
    bash_completion.install libexec/"etc/bash_completion.d/youtube-dl.bash-completion"
    fish_completion.install libexec/"etc/fish/completions/youtube-dl.fish"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
