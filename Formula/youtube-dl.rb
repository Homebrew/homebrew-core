class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/96/50/a91e7e398c359fd01293f82298d903fea182b744f98682e772b6f8d1ae3c/youtube_dl-2020.12.7.tar.gz"
  sha256 "bd127c3251a8e9f7a0eb18e4bbcf98409c0365354f735c985325bc19af669a24"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb888df4b077852b52ee20f24b357a53765c63ac2b158850885b4f9a6413b74d" => :big_sur
    sha256 "75b164d8356512900032fc1fe1a862cfa81503f09c73ca9a06dd06584ccd40c3" => :catalina
    sha256 "aede38d0e537d566746d4457118f8297dbc2dd1d5b989b5c578581fa801db950" => :mojave
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
