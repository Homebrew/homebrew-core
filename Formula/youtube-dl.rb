class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/67/2b/c16c06e8929013a1e0d8962fd5baf29c3ddddd31a5246750c4967630906b/youtube_dl-2021.2.4.tar.gz"
  sha256 "16a5e57a24e56bd3557b57bc8c438efa23a13aeff7ce7a04941c5e307f8148bb"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6365fff0a0ebb8bf3124b6fc0982ecbc96fbba544b36ca2d538055d15c9a40e" => :big_sur
    sha256 "425a3fb56e783ea5d696f1f77c99da20f11d4ed56350499ce3eec102e6e38a97" => :arm64_big_sur
    sha256 "7241294d138df35a1bcb2cb85875b2641bd7c02ef4b1bc00a5294d09a0b2a9b5" => :catalina
    sha256 "a59855ed2c20d3fd2e3d469f1e1439e01f8d31da81d00b98e9dbcd4b2fa68bfd" => :mojave
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
