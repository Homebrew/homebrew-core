class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/44/ee/35b6ad9f8354fd36bef496205ddd6e19b12fa0142655594f2cdea27a5465/youtube_dl-2021.2.22.tar.gz"
  sha256 "adcdec2b72ab7b68cd50a4d1e6581173353bcd6f0be175824a4b72ae890d9ae7"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "59bb20682e45ed2a4a8172b4a67260b65fde3789387a6a1295a47e7c9a1a38fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d0390a1788d7617dd7e613681d7a0312835fe2c7c6245c33de2e3f2fff25504"
    sha256 cellar: :any_skip_relocation, catalina:      "3d11944e62ae6e3b414adf7b9b09ecb136f54a6c27ef56d5672b0bef28c90d78"
    sha256 cellar: :any_skip_relocation, mojave:        "24ea5e9adc4b141e6ee6d305be8fabcf8a4e792b7482317a551c58838fa18d04"
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
