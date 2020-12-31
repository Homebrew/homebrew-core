class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/1b/94/b2cd268e94b136f5540423b1dd511cdc8c0faf1b70adae153d8730670927/youtube_dl-2020.12.31.tar.gz"
  sha256 "173fca869f8d2a6008cd7d13627f368adc1f334e973f49f03a3fe62b16ac2fea"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "60895c95d771ee9bad583614415d9faee69aea72e8a11d1fe5c0286085e479ab" => :big_sur
    sha256 "de918e2b96aeb4663bdcb47f330001d3f79f08e8f063577b2d3887edf4dbbee6" => :arm64_big_sur
    sha256 "9da1c597f91306484fb10e772f428307f9df9ef1b4a4440ebea9867eefd7cc87" => :catalina
    sha256 "9c3cf92a9a3f21b6124e096a9a76ca876a634a47516f9c5c0fcc9dbf584c17c0" => :mojave
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
