class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/b2/d3/a81e02eddc6ce93f160f187103f30c93a5ca787ea24dccd4dc5205a2eb12/youtube_dl-2021.2.4.1.tar.gz"
  sha256 "b337f20563094decc6b3c16e6fcad14ec3df9d99519344d6e95e40878b2c8075"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae4d3339e865293d91492f340945c65f959bf48f843410e1f4d02a77be023633"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3162b3444b1a97e3f5ea669726695e1533f603b6ac6840f0e8541a2c89b95fe"
    sha256 cellar: :any_skip_relocation, catalina:      "b466d68fa69917f9389c1740f09a0f234873638151e446731c2c601fa87ee09d"
    sha256 cellar: :any_skip_relocation, mojave:        "496bfe25e6ed8585ce475edfef0f23f17a34e1fd63cee418bdb512fdb93a4bbd"
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
