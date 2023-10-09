class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/cd/89/1d289162b4ddc6282cbe97201707653d13afcdf39d23ac8d700aef22bd7a/yt-dlp-2023.10.7.tar.gz"
  sha256 "fc86657a9b240cf65fef3ff627e4a0de335e725936fe70d4402c71dd97452f36"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f03b662a23f002c76305ba4eeab81e6f9b9400c0b9c095ba2d15668fdc799850"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f735627807b16ddb9e0b811f22e0f8e3407d797e0c452a794a3a03c1aa86d771"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a91d5e5f16e0097cec395fe81e2e6695346d5bb8b01a0059d155e341b147babb"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d5059d05768e26c8781343cc9d026dd4f422a8cbce184a9b0080ff4232be5f1"
    sha256 cellar: :any_skip_relocation, ventura:        "1059d1fbe8fe8fb158f62b794b59df545ad967fe8362a477de38ab6ff3603378"
    sha256 cellar: :any_skip_relocation, monterey:       "f64cc701c07c8d83bb7fa401dd5e3416a351761fe7eb792cbbd16b78da0f2ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0958857a404b6f067521666ab05f6bae786bc214ea4da67e2e62a78a8cb74f"
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
