class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/db/7f/8bdf5c78fc01a71f1babcc813b972996144b46ee88394356f4a188686db5/yt-dlp-2023.10.13.tar.gz"
  sha256 "e026ea1c435ff36eef1215bc4c5bb8c479938b90054997ba99f63a4541fe63b4"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea6c873efc1c3d30f6e6fb57b25b285b52b124b95a7264b9073fe6e996c096a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d7adf91534bf7bbc741e748a75627eda3feb351748b84c9a7ac4eb69ab23c7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85040fce14c698d904168c653154e02ed7215a13a6501f50f41ce7dde92fe990"
    sha256 cellar: :any_skip_relocation, sonoma:         "193cba5872dbccd6bdac6171b56980a5d31ef7062fbd980fbc82f2f7b49f250f"
    sha256 cellar: :any_skip_relocation, ventura:        "168c8f475eab8242106c44a0d0b16c5739721f3ecdd5db6ccdaf8b53e44887d1"
    sha256 cellar: :any_skip_relocation, monterey:       "8f52272b731ca201a55394e470d5fdefb4cc665952832b0a9301795f492ec977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcd68f9bf1783ce87753a1246d0a2cc202bf634e7dc00d6e68ebc1aa9b40d269"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python-certifi"
  depends_on "python-mutagen"
  depends_on "python@3.12"

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
