class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://files.pythonhosted.org/packages/ec/4b/125fc0d84de9eafe9be299f4b1aba0af78c72f555a159037ebe6c7a3efc5/streamlink-3.1.0.tar.gz"
  sha256 "4f6334be0f8160876bdb509c76bac17fb6d5565654fad289586db17c13283258"
  license "BSD-2-Clause"
  head "https://github.com/streamlink/streamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6547aa4d4e68e0df594f7ea3f0708280e2cfda25955d0f5da90e62fb17469897"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "994ff304e5fa169c3c027479010910885b736400ee55c7d3e13d683c3b2af449"
    sha256 cellar: :any_skip_relocation, monterey:       "4f0fbb742461e66892b3e0b290540fa72a43ca6b00741394a305b5fd32ccefc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7546e9707dc7857de742496663d7b657a2207b294e373aef678ad91ff6d1da8"
    sha256 cellar: :any_skip_relocation, catalina:       "5996694883ba88637c03c91d0d4fc83d4706b331d3edcef3494b53fe8d721b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bac7c0cbdd7ac22971bb8364abfb5542acfba49b5c2cd90da8deef0ca8da5395"
  end

  depends_on "python@3.10"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/48/44/76b179e0d1afe6e6a91fd5661c284f60238987f3b42b676d141d01cd5b97/charset-normalizer-2.0.10.tar.gz"
    sha256 "876d180e9d7432c5d1dfd4c5d26b72f099d503e8fcc0feb7532c9289be60fcbd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/84/74/4a97db45381316cd6e7d4b1eb707d7f60d38cb2985b5dfd7251a340404da/lxml-4.7.1.tar.gz"
    sha256 "a1613838aa6b89af4ba10a0f3a972836128801ed008078f8c1244e65958f1b24"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/03/c4/2db520ae518156a88b419b2865d4fdc85fe78573948358f79dbaf0cf2b30/pycountry-22.1.10.tar.gz"
    sha256 "b9a6d9cdbf53f81ccdf73f6f5de01b0d8493cab2213a230af3e34458de85ea32"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/dd/3b/38d83c2725fec5b837fc05d5c6e0178a420ff839a6ad5872f10c89244899/pycryptodome-3.12.0.zip"
    sha256 "12c7343aec5a3b3df5c47265281b12b611f26ec9367b6129199d67da54b768c1"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b6/fa/72e77d094563208174abbbaa73c32f28c43a31193b843bddf233c7c87644/websocket-client-1.2.3.tar.gz"
    sha256 "1315816c0acc508997eb3ae03b9d3ff619c9d12d544c9a9b553704b1cc4f6af5"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/streamlink.1"
  end

  test do
    system "#{bin}/streamlink", "https://vimeo.com/189776460", "360p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MP4 v2", shell_output("file video.mp4")
  end
end
