class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://ytdl-org.github.io/youtube-dl/"
  license "Unlicense"

  stable do
    url "https://files.pythonhosted.org/packages/01/4f/ab0d0806f4d818168d0ec833df14078c9d1ddddb5c42fa7bfb6f15ecbfa7/youtube_dl-2021.12.17.tar.gz"
    sha256 "bc59e86c5d15d887ac590454511f08ce2c47698d5a82c27bfe27b5d814bbaed2"

    # Backport fix for extractor handling consent
    patch do
      url "https://github.com/ytdl-org/youtube-dl/commit/aaed4884ed9954b8b69c3ca5254418ec578ed0b9.patch?full_index=1"
      sha256 "3078402768839f4ad611bcb7ab3b221d1a97626c62c4f1bdb2f85598fa45fa96"
    end
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86ad6daf8ba59b37855706201030abfdfa6a334d66ee80ee6351212baa1fccaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f0777822da37695c41651a1745fda40a3bda17b7d252b682c74eaa8591023b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1ac5fa2ec5d0dc609a2a52b5862da268bcd2731609aa114491b787105701f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d203c17f40f2e3ab8e1d3887539ae66173c4e91b36d28024e7bd98e41c2407a3"
    sha256 cellar: :any_skip_relocation, ventura:        "41ea7b884710606f9e4b2e98d186815d1be48a13fa6e3c945c2c686fec48e25f"
    sha256 cellar: :any_skip_relocation, monterey:       "f78df8ae4f3c7b6f84f8d2a94bfb1187219c0b2c46a8a2859bf1061940068820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2abdf78bc998a6fde5c66488e36411df9c0d8326554a031c3dd32aaef651af2c"
  end

  head do
    url "https://github.com/ytdl-org/youtube-dl.git", branch: "master"
    depends_on "pandoc" => :build
  end

  # https://github.com/ytdl-org/youtube-dl/issues/31585
  # https://github.com/ytdl-org/youtube-dl/issues/31067
  deprecate! date: "2023-11-23", because: "has a failing test since forever and no new release since 2021"

  depends_on "python@3.12"

  def install
    python3 = which("python3.12")
    if build.head?
      system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "PYTHON=#{python3}", "install"
      fish_completion.install prefix/"etc/fish/completions/youtube-dl.fish"
      (prefix/"etc/fish").rmtree
    else
      virtualenv_install_with_resources
      # Handle "ERROR: Unable to extract uploader id" until new release
      # https://github.com/ytdl-org/youtube-dl/issues/31530
      inreplace libexec/Language::Python.site_packages(python3)/"youtube_dl/extractor/youtube.py",
                "owner_profile_url, 'uploader id')",
                "owner_profile_url, 'uploader id', fatal=False)"
      man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
      bash_completion.install libexec/"etc/bash_completion.d/youtube-dl.bash-completion"
      fish_completion.install libexec/"etc/fish/completions/youtube-dl.fish"
    end
  end

  def caveats
    <<~EOS
      The current youtube-dl version has many unresolved issues.
      Upstream have not tagged a new release since 2021.

      Please use yt-dlp instead.
    EOS
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
