class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audio/video downloader"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/fd/e9/61fc5947d35e9fcdd8efca88a5a2de53946a4aaf4e6c3e23f7b1b721b4c8/yt_dlp-2025.1.15.tar.gz"
  sha256 "e8ec515d49bb62704915d13a22ee6fe03a5658d651e4e64574e3a17ee01f6e3b"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9c43c736e8aac626f2dbacf303161bd9434b669eaa83d386f95213b877f345d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a34a3e9d9348b272f8c014a60dbfb807d4f5a0cf90db0cc57c50d5f523a46168"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "892d8b6cc0894e7368760eb19db6153544233229f6bce9b5ff4292b9dc7eb763"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba6a08f1eb33010e36e74e901120f11f0a7ca56b028ebf2f84c127e8d71d701d"
    sha256 cellar: :any_skip_relocation, ventura:       "4d44f393ecab05230bd6f050ed8d0e59c00fa37eac3351f89d9ee652d549bd82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4276e4999644992333bf15264aabe49bf142075645ebd57fe0b8bde7c15bf3d"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

    depends_on "pandoc" => :build

    on_macos do
      depends_on "make" => :build
    end
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/11/dc/e66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828f/pycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/f4/1b/380b883ce05bb5f45a905b61790319a28958a9ab1e4b6b95ff5464b60ca1/websockets-14.1.tar.gz"
    sha256 "398b10c77d471c0aab20a845e7a60076b6390bfdaac7a6d2edb0d2c59d75e8d8"
  end

  def install
    system "gmake", "lazy-extractors", "pypi-files" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    system bin/"yt-dlp", "https://raw.githubusercontent.com/Homebrew/brew/refs/heads/master/Library/Homebrew/test/support/fixtures/test.gif"

    # YouTube tests fail bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    system bin/"yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
