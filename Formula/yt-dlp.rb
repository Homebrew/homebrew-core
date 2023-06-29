class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/57/86/b5fb11442d96a7a438ec6ad27d04c546f4f7e64c3d551259f886adeddb8e/yt-dlp-2023.6.22.tar.gz"
  sha256 "ed6a8b8e0ad08a4540d4afa0fd08a7f980022c79b9081bd9e63ddc00aeeee5a8"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c401bdf6e43897e96b79126ca3398ce4aa0465d20ff1afaee4331fe5604ecdee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35694104825ac09ad02ac159bb123a2912fd3291750203f972d6a8f8b0001478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1f5d83069269f1a57b37b4c70ea3a7ae26e54a1be044f2c44364e0bf238f45c"
    sha256 cellar: :any_skip_relocation, ventura:        "bce83af3532484ed1313b39721625c436750b4c087224865f8328ac58592b87a"
    sha256 cellar: :any_skip_relocation, monterey:       "e55d093fcbbad6a7cfe9f83d4df26c1aef5dd68be35d857ed18924a18b21d8ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "018cc0dd8e6cb1921668b9bf95981d246a13b42476e49c7a7dc64e0657a70767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d234fba8410c0f91a23ccf0b6caaf2fad38ce13a88e6161409938cdf0d82a9"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/40/92/efd675dba957315d705f792b28d900bddc36f39252f6713961b4221ee9af/pycryptodomex-3.18.0.tar.gz"
    sha256 "3e3ecb5fe979e7c1bb0027e518340acf7ee60415d79295e5251d13c68dde576e"
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
