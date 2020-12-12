class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/65/18/b0d101ef8e0b09acf9d8a3cd10be301e36c62af70f1409aed210d5caa6dc/youtube_dl-2020.12.12.tar.gz"
  sha256 "a57bab1cfc3d57ae84e26e735daac498fd7b54261fe911e5ba58acfd0ed71742"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "173c01333ebce5a7e1b8f085e2669ab11f03e907c5e3c5d9bab7375597c6fc73" => :big_sur
    sha256 "f14ac8f82a687cc3b975b78e71d98b2c550d78a104dfd893d9b537a8f0551c03" => :catalina
    sha256 "102acd46312e05a0f9db002680470c47353815425550567f82c01814c56892f6" => :mojave
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
