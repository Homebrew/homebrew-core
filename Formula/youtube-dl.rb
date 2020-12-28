class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/9b/ec/e80915968a24da8d79d537a01259646f0c8e41d5c6eef6c3c722828e3e18/youtube_dl-2020.12.29.tar.gz"
  sha256 "98bd918182b88930ee40c4f67926d2c2c15731df3807721c37c4a7914457484c"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "540d08b3288fcb89c4f13584aac2a62df8db6c4f0deff4817902aba5c163083e" => :big_sur
    sha256 "5a573947f43390861cc3198adb30bb3eb746f14dfbccadc1ae6eb4cfba658ad6" => :arm64_big_sur
    sha256 "542a43dd337e63079f5f8c4ebe2e3d32cbe2fb8286515bbb2878c83213085b23" => :catalina
    sha256 "98c151c454642d54306832126f66cdcf1922f7dc1929784fe19b4c4145824d99" => :mojave
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
