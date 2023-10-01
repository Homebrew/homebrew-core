class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/66/2d/14a4e2d2b0a5a03d781cc1603c07d9f89c36ae4e1ba22e74e084d3d08201/yt-dlp-2023.9.24.tar.gz"
  sha256 "cfcfb5ffc12013b6ae4b8c7a283a7e462988f1b49283de291de8bfbe053b8073"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e969f55a4da6f2a5f060a2bb378fc1cc38d34e6c9da8d7952f719b034df72da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "032c6ab2b83114908cbfc8187a7c3b61a6b16f8ba1d0c3a7c74c34344a3f8ed7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abc5b95355e7db7d07aeabc7b5582b5551b55219f53ee99d8fe806036943382e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a9f3431c99059409db45a383ef680f66a0368757270fa0be56083e53ba0e82e"
    sha256 cellar: :any_skip_relocation, sonoma:         "07deea0bd4c5dd2ba7aa566ce51d8ebbf07ba5c695c38c446b853c71cc4896e4"
    sha256 cellar: :any_skip_relocation, ventura:        "fe1bf5fd3ca05e76eca05c2842e88f5a9d5ea1fce04c27130e115ab907607aa5"
    sha256 cellar: :any_skip_relocation, monterey:       "47790e31d6134508fa64fd1a565bedeae01480892cb675c244a500e1978cc92d"
    sha256 cellar: :any_skip_relocation, big_sur:        "59f9b8810a5de5163996945183d53edd203f92e5bb656209453b01b287fac987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1685fadde1e00ca5d7fcbb019505102abfd02d17345533fce9acb8f2579bf93f"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python-certifi"
  depends_on "python-mutagen"
  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/c9/09d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53/pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
  end

  def install
    system "make", "pypi-files" if build.head?
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
