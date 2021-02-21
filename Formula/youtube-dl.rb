class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/44/ee/35b6ad9f8354fd36bef496205ddd6e19b12fa0142655594f2cdea27a5465/youtube_dl-2021.2.22.tar.gz"
  sha256 "adcdec2b72ab7b68cd50a4d1e6581173353bcd6f0be175824a4b72ae890d9ae7"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbe54c071364353daf7e78e3c17d9ebec06ead33fa9cd0d6375626ad774cd866"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbd6c70eb6661847f6c9d6f497741f770b49d8b9a3534a32c369d3ed1e53963f"
    sha256 cellar: :any_skip_relocation, catalina:      "d7092d99acdbcac8acad26f0278d369a74fda84c1146de3d3c7b7fce261b616f"
    sha256 cellar: :any_skip_relocation, mojave:        "851fb88bf41334bc1edd187f9aa2dd59fbe06bac56c188d1c0f8bd33ecf856e5"
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
