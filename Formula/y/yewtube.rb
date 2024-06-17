class Yewtube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/yewtube"
  url "https://github.com/mps-youtube/yewtube/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "8100466a5e89c84249d882e2e9ea9ff282a2d4f7f68135157cb942e6eb927b29"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42dc4906eb295b3d65f6976558afb890f207099d1fcc945f58ba7ddb6792ff9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de584ab6568bb31f7e7effa7735716ea70a4d5c411358353055036b038ac25cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f62b0d81fc5af8a76b64ccbc6cb4c14213ee6b2404178c07f561b54892d1eec7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2da7aa4c9c70ac69ae33efe9efe948fe2a7b231169b09f3bae461b27d4559719"
    sha256 cellar: :any_skip_relocation, ventura:        "22f324b54293b6b77351617c6f10e62bea92522f7cb594cb27ce46db694f8dcb"
    sha256 cellar: :any_skip_relocation, monterey:       "a80ae86e87abb111fd4f139848d44325e3e9f0600bab314a658da08d72f1e44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4772aa92e1a8b5b3ba0de7e2403d3d99a3d6bd1b5a7459f4bcc92e6fbcecfedb"
  end

  depends_on "mplayer"
  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/db/4d/3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3/anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/71/da/e94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96/certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/17/b0/5e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926/httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/5c/2d/3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0/httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/31/a4/b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1/pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pylast" do
    url "https://files.pythonhosted.org/packages/c0/0e/da064214d2595dc0dedc6db11379b961cdc128054728cd4f81830ff925b5/pylast-5.2.0.tar.gz"
    sha256 "bb046804ef56a0c18072c750d61a282d47ac102a3b0b9c44a023eaf5b0934b0a"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "youtube-search-python" do
    url "https://files.pythonhosted.org/packages/91/3c/dc669b0308e49f294df67bddbb16ff3eefe5b5da6fa37ead922a8301926b/youtube-search-python-1.6.6.tar.gz"
    sha256 "4568d1d769ecd7eb4bb8365f04eec6e364c5f70eec7b3765f543daebb135fcf5"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/52/85/af44c30f0cc5d94ebbce365f8ee40eea6e9d7a1d26d50f16e3766ca8410c/yt_dlp-2024.4.9.tar.gz"
    sha256 "7ee90572b4d313b582b99c89e4eccf779b57ff54edc331873c6b3fba77faa8b0"
  end

  # Fix SyntaxWarning's on python 3.12
  # https://github.com/mps-youtube/yewtube/pull/1263/
  patch do
    url "https://github.com/mps-youtube/yewtube/commit/0db8c9e567399b2da0c77d95834832cbb4082544.patch?full_index=1"
    sha256 "1c28b5b8fb8a66db310e326274029e5b097841af4d944af965899447c0e600ae"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Install the optional mpv app with Homebrew Cask:
        brew install --cask mpv
    EOS
  end

  test do
    system bin/"yt",
      "set checkupdate false,",
      "set ddir \"#{testpath}\",",
      "/youtube-dl test video,", "d 1,", "q"
    downloaded_file = (testpath/"mps").children.first
    file_info = Utils.safe_popen_read("file", "--brief", downloaded_file).strip
    assert_match(/^(WebM)|(.*MP4.*)$/, file_info)
  end
end
