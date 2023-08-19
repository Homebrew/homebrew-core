class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/01/4f/ab0d0806f4d818168d0ec833df14078c9d1ddddb5c42fa7bfb6f15ecbfa7/youtube_dl-2021.12.17.tar.gz"
  sha256 "bc59e86c5d15d887ac590454511f08ce2c47698d5a82c27bfe27b5d814bbaed2"
  license "Unlicense"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1785d927f08c742e1a5be3b7e78720b9b59ecbf0629097fbd3ac5f38f44c7660"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1785d927f08c742e1a5be3b7e78720b9b59ecbf0629097fbd3ac5f38f44c7660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1785d927f08c742e1a5be3b7e78720b9b59ecbf0629097fbd3ac5f38f44c7660"
    sha256 cellar: :any_skip_relocation, ventura:        "4a0b4ff89c2e65e477927b6e62d8aa5d9de8cfb7f655f482d847898bd61071cf"
    sha256 cellar: :any_skip_relocation, monterey:       "4a0b4ff89c2e65e477927b6e62d8aa5d9de8cfb7f655f482d847898bd61071cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a0b4ff89c2e65e477927b6e62d8aa5d9de8cfb7f655f482d847898bd61071cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "176587c275b69443d195a8e3c88c392905bdd6c78614207da18093fb35962ee0"
  end

  head do
    url "https://github.com/ytdl-org/youtube-dl.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python@3.11"

  def install
    if build.head?
      system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "PYTHON=python3", "install"
      fish_completion.install prefix/"etc/fish/completions/youtube-dl.fish"
      (prefix/"etc/fish").rmtree
    else
      virtualenv_install_with_resources
      # Handle "ERROR: Unable to extract uploader id" until new release
      # https://github.com/ytdl-org/youtube-dl/issues/31530
      inreplace libexec/"lib/python3.11/site-packages/youtube_dl/extractor/youtube.py",
                "owner_profile_url, 'uploader id')",
                "owner_profile_url, 'uploader id', fatal=False)"
      man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
      bash_completion.install libexec/"etc/bash_completion.d/youtube-dl.bash-completion"
      fish_completion.install libexec/"etc/fish/completions/youtube-dl.fish"
    end
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
