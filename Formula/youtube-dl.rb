class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/b6/d5/f003ec65e6bcfe475abddbfb3271159736be6ebca2ab95796c0f2e8ee184/youtube_dl-2020.11.29.tar.gz"
  sha256 "849d2a85ee99e5caafc8d52572bb603c4ae020dfb615a4d51c3bc90787d40df3"
  license "Unlicense"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f7cab9112815a0e18f0531029cd875f616a5b5aa910901798df87de21c19422e" => :big_sur
    sha256 "31f217e3afc01c30fbe84a8db3754191db59579a700be50a1150817a46438a38" => :catalina
    sha256 "7bc643f206a2e55c429e63719d121423698b720d0d94e410f4118743ffd1199a" => :mojave
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
