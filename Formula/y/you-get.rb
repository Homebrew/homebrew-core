class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/7e/87/5faa48930348f57c26109b623accdf0517ac82253fa3c236ba1131d35f5d/you-get-0.4.1700.tar.gz"
  sha256 "5cd21492012a446ac1b52c6f7e44944aac65b59e997645a84dcf64cf8043e99c"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44db7e8ed6b8cd539df6e9eb8323dee1d1f8dcafcc2e3df4b120bf45d04f52cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5be0e99a1242bf98bdee82387986568089d405cae42f3f5eccda511038ae34da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "027883df0ea0e7ee7ce198d29d9bc9f25a35c77cb23a1d0368e372872c03d223"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8915d2d55f9efd64fc2d92ca1c03416f3c60048c170ad773de57c52d360f007"
    sha256 cellar: :any_skip_relocation, ventura:        "7be679382bbf7ea9fe0104dbc5947b320040ae46e1964c91a50be1018c56ffd7"
    sha256 cellar: :any_skip_relocation, monterey:       "f21f40a5f4bc7bf8a50eabecea4fed5dcefe9d8db466e6cb3c4e6031d23f4430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ad289e626860506fa04e4758dec81146ebdf42027d6a9177547f66228c6f2a"
  end

  depends_on "python@3.12"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
    bash_completion.install "contrib/completion/you-get-completion.bash" => "you-get"
    fish_completion.install "contrib/completion/you-get.fish"
    zsh_completion.install "contrib/completion/_you-get"
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
