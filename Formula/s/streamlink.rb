class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://files.pythonhosted.org/packages/4e/49/496c1dcd299bec19f5cc9b9e9b07c5baa7a774e4f960d3b18c6e821d60c9/streamlink-8.0.0.tar.gz"
  sha256 "fb6252b87cb1d4d14dfc5bf1f4add1001e87016b150b7495e22e97aeae264655"
  license "BSD-2-Clause"
  head "https://github.com/streamlink/streamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8721a44823b99226f716d3ab748ac29c24f090c4877fb47d8418fca87b92774"
    sha256 cellar: :any,                 arm64_sequoia: "106b99f57153da388362fb8bb9ba5fcd4e14d8c5e504ee765642a80390a9d48c"
    sha256 cellar: :any,                 arm64_sonoma:  "30c25094846d1fd940b523fad8b87eddda280c9b69866d67ad5e500338a51152"
    sha256 cellar: :any,                 sonoma:        "132fad2a3ea5125c9bc67837cc4087ead77f5f4888a3f728916ae7ecb06bfc45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "416da3ec443eb8bb590a22806d620626f6c77805bf187529f544f8d816501b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93c67a878aeeefc86db4dbc50840690e2fa331326ff53ee5aae25400728c50f"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libxml2" # https://github.com/Homebrew/homebrew-core/issues/98468
  depends_on "python@3.14"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/98/df/77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2/outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/76/57/c389fa68c50590881a75b7883eeb3dc15e9e73a0fdc001cdd45c13290c92/pycountry-24.6.1.tar.gz"
    sha256 "b61b3faccea67f87d10c1f2b0fc0be714409e8fcdcc1315613174f6466c10221"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/d8/ce/0041ddd9160aac0031bcf5ab786c7640d795c797e67c438e15cfedf815c8/trio-0.32.0.tar.gz"
    sha256 "150f29ec923bcd51231e1d4c71c7006e65247d68759dd1c19af4ea815a25806b"
  end

  resource "trio-websocket" do
    url "https://files.pythonhosted.org/packages/d1/3c/8b4358e81f2f2cfe71b66a267f023a91db20a817b9425dd964873796980a/trio_websocket-0.12.2.tar.gz"
    sha256 "22c72c436f3d1e264d0910a3951934798dcc5b00ae56fc4ee079d46c7cf20fae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"streamlink", "https://player.vimeo.com/video/941078932", "240p", "-o", "video.mp4"
    assert_match "video.mp4: data", shell_output("file video.mp4")

    output = shell_output("#{bin}/streamlink --ffmpeg-no-validation -l debug https://ok.ru/video/1643385658936")
    assert_match "Available streams:", output
    refute_match "error", output
    refute_match "Could not find metadata", output
  end
end
