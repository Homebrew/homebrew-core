class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://files.pythonhosted.org/packages/26/3a/280bad1cc57743d1a0ed0a157fa58ff3231db326e4ba41195fc912a1deef/streamlink-4.0.1.tar.gz"
  sha256 "f38a4fd5c45b1628e7ebee43ba7f8522be5045565aa7c64009740baf853f20f5"
  license "BSD-2-Clause"
  head "https://github.com/streamlink/streamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ffbd20114fe8511d78810c32b06ea7b4ed36d175be2e77cb2869c972df12811b"
    sha256 cellar: :any,                 arm64_big_sur:  "3d258db7c57e65dba9867404a7d18b78c34930ef3c51eb06e8529bacbd33a141"
    sha256 cellar: :any,                 monterey:       "5feca00ed134cae835c6c8319ffc64ec3f5582278216244c56951d9ab3d36e52"
    sha256 cellar: :any,                 big_sur:        "340af5df6524f3bd02f53bb409c5565915c3e30f827e1dfa5ac30844b6611376"
    sha256 cellar: :any,                 catalina:       "de16fdf0b163af277c682ecc8e7ee46bb14cde3de6916e61bd7187d0e097f8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3304101f9d7173d15ea991bab30b0f9bb51998d834d6bc4ca8e11cb6f59d63c0"
  end

  depends_on "libxml2" # https://github.com/Homebrew/homebrew-core/issues/98468
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
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
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/33/24/033604d30f6cf82d661c0f9dfc2c71d52cafc2de516616f80d3b0600cb7c/pycountry-22.3.5.tar.gz"
    sha256 "b2163a246c585894d808f18783e19137cb70a0c18fb36748dc01fc6f109c1646"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/32/09/41ea2633fea5b973dac9829de871b417ff3ce2963d07fd92e3f2d2a9ee9b/pycryptodome-3.14.1.tar.gz"
    sha256 "e04e40a7f8c1669195536a37979dd87da2c32dbdc73d6fe35f0077b0c17c803b"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/7c/de/9f5354b4b37df453b7d664f587124c70a75c81805095d491d39f5b591818/websocket-client-1.3.2.tar.gz"
    sha256 "50b21db0058f7a953d67cc0445be4b948d7fc196ecbeb8083d68d94628e4abf6"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/streamlink.1"
  end

  test do
    system "#{bin}/streamlink", "https://vimeo.com/189776460", "360p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MP4 v2", shell_output("file video.mp4")
    output = shell_output("#{bin}/streamlink -l debug 'https://ok.ru/video/3388934659879'")
    assert_match "Available streams:", output
    refute_match "error", output
    refute_match "Could not find metadata", output
  end
end
