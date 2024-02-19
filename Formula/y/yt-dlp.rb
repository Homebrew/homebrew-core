class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/a9/a7/d8536993aed7569c5221f532e3ba01b09d5bdc893df3ef4e5b05d01582c4/yt-dlp-2023.12.30.tar.gz"
  sha256 "a11862e57721b0a0f0883dfeb5a4d79ba213a2d4c45e1880e9fd70f8e6570c38"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d33fd0ab9779c1f81744dd13ff8ffc5dc1b8a0c5031465c4018df3ebb07ecb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37e71124a9046d067fd285d5392d9b0a6dc0d523d11d7670fd04bc66bab485b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd64c615671def55988d5b706e90570c48d1ed64b5b677bcff2e163b8d229d4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "73021ddbf4773ad16bed9e12684ccf4be97ab2b16161d4c894ceb0af95c54e18"
    sha256 cellar: :any_skip_relocation, ventura:        "97010489db6966283c84e983fbe771d663b412c63914c4112845216053613a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "6233262e187f4cd803af849972d9606a8243d055524629a9b768001c5e9457e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da2b313f112ffb787fd90c64aee98a6e6f568e16975f89112cfe4bf641e32004"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
    on_macos do
      depends_on "make" => :build
    end
  end

  depends_on "python-brotli"
  depends_on "python-certifi"
  depends_on "python-mutagen"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/3f/13/84f2aea851d75e12e7f32ccc11a00f1defc3d285b4ed710e5d049f31c5a6/pycryptodomex-3.19.1.tar.gz"
    sha256 "0b7154aff2272962355f8941fd514104a88cb29db2d8f43a29af900d6398eb1c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def install
    system "gmake", "pypi-files" if build.head?
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
