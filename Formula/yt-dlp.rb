class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/ee/59/d763a51fa975639946c327ffbf85e109dbaa87f8aa5cae54a4ee5d09593c/yt-dlp-2021.8.10.tar.gz"
  sha256 "8da1bf4dc4641d37d137443c4783109ee8393caad5e0d270d9d1d534e8f25240"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96d6684e34d20fa121b4bad4c0706f024bb1a406ece55db3a188e0e4bd8f08c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d5e6d8606ec77e6c992a986ed964a1d8a5b45464d59bbf2d99d7130afba3c76"
    sha256 cellar: :any_skip_relocation, catalina:      "3d5e6d8606ec77e6c992a986ed964a1d8a5b45464d59bbf2d99d7130afba3c76"
    sha256 cellar: :any_skip_relocation, mojave:        "3d5e6d8606ec77e6c992a986ed964a1d8a5b45464d59bbf2d99d7130afba3c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6e65096ceac3c5270ad48b2e5f8381317dbbbe687052f1003b55d927fc6454"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
