class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://ytdl-org.github.io/youtube-dl/"
  url "https://files.pythonhosted.org/packages/01/4f/ab0d0806f4d818168d0ec833df14078c9d1ddddb5c42fa7bfb6f15ecbfa7/youtube_dl-2021.12.17.tar.gz"
  sha256 "bc59e86c5d15d887ac590454511f08ce2c47698d5a82c27bfe27b5d814bbaed2"
  license "Unlicense"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91ddcd5a78a536d49b1dd461b1f841611cbf641fae881aa4b88fd354451d9848"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5c07f4bf1dba666a29a383db3a93e999e21e87cbd897247fe90bd48bbbd6629"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e8e5b503f45df8295c549bd1b3c8852eddeb1a820ef83609346ff05eb0aef42"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa5eed9e9d1c14f924f90b67c653cc0207e22bb86ee3280fb5e9f114383c7bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "b05a5de77bed702e043fa611811597321b92c15b3d8ee5d7abc07db452966219"
    sha256 cellar: :any_skip_relocation, monterey:       "5c53c7c184fe002c221ce12eef1dde7aba6dc200b8f63a2fb55db1c2059ae85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db272dcc243e7d6ad084e1c63e407379be8501eb7727f13445b04ea0bd5dffc8"
  end

  head do
    url "https://github.com/ytdl-org/youtube-dl.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python@3.12"

  def install
    if build.head?
      python = Formula["python@3.12"].opt_bin/"python3"
      system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "PYTHON=#{python}", "install"
      fish_completion.install prefix/"etc/fish/completions/youtube-dl.fish"
      (prefix/"etc/fish").rmtree
    else
      virtualenv_install_with_resources
      # Handle "ERROR: Unable to extract uploader id" until new release
      # https://github.com/ytdl-org/youtube-dl/issues/31530
      inreplace libexec/"lib/python3.12/site-packages/youtube_dl/extractor/youtube.py",
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
