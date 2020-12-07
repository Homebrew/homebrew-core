class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/96/50/a91e7e398c359fd01293f82298d903fea182b744f98682e772b6f8d1ae3c/youtube_dl-2020.12.7.tar.gz"
  sha256 "bd127c3251a8e9f7a0eb18e4bbcf98409c0365354f735c985325bc19af669a24"
  license "Unlicense"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "699bf24c8143ee101c47719766c8ad0cbccf8725381773dca8112bc636a54148" => :big_sur
    sha256 "f0e9d0373e1b4e2aba7f878cafb23c3f6a95d39c0be66f3b66dbb229c1da305d" => :catalina
    sha256 "2cfcce83af506b23bcc7f694e3e47d70dd20d93a493d2260e4236cdcf7b42401" => :mojave
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
