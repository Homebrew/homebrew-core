class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://files.pythonhosted.org/packages/83/de/789bbd4e7eefbb32f9e4d4c6439e13ef22fd46360bdd84060e60fb01958c/streamlink-6.2.0.tar.gz"
  sha256 "aeae1b7848446f90998c62324e7107c8f41f8c08266dbc419b81e1cc1b35559a"
  license "BSD-2-Clause"
  head "https://github.com/streamlink/streamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63e8b10d8e38cd56f8fc133bfddc4952f33e889e4141f4204b043a0e646c4962"
    sha256 cellar: :any,                 arm64_monterey: "5077e77eed242d779ae24ba17c2b22675a6c6d9cfa04490db287ce021e2e8317"
    sha256 cellar: :any,                 arm64_big_sur:  "08511925a3804a10bcbcee72a0dd9839a70632a00b4d3aea574833d3635fdb77"
    sha256 cellar: :any,                 ventura:        "50fe3a85ec88d3a00d779ca2949d96004e6d56172ea1e82de442e9d3862e922c"
    sha256 cellar: :any,                 monterey:       "3d715f5d435da272b26f21feeb35dabc23d8365b0c34676ae71c9c3277cbaa8b"
    sha256 cellar: :any,                 big_sur:        "0cbb0bbef642ac7757aad4a43e044c44638fb123e95e2c98d60b9526f79c7bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e66cb0588a7a12f399caa0d735b49094e544cc33dcddba8af5bfec5d32fe48"
  end

  depends_on "libxml2" # https://github.com/Homebrew/homebrew-core/issues/98468
  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/c2/e1/5561ad26f99b7779c28356f73f69a8b468ef491d0f6adf20d7ed0ac98ec1/exceptiongroup-1.1.3.tar.gz"
    sha256 "097acd85d473d75af5bb98e41b61ff7fe35efe6675e4f9370ec6ec5126d160e9"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/dd/91/741e1626e89fdc3664169e16300c59eefa4b23540cc6d6c70450f885098f/outcome-1.2.0.tar.gz"
    sha256 "6f82bd3de45da303cf1f771ecafa1633750a358436a8bb60e06a1ceb745d2672"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/33/24/033604d30f6cf82d661c0f9dfc2c71d52cafc2de516616f80d3b0600cb7c/pycountry-22.3.5.tar.gz"
    sha256 "b2163a246c585894d808f18783e19137cb70a0c18fb36748dc01fc6f109c1646"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/04/b0/5ec370ef69832f3d6d79069af7097dcec0a8c68fa898822e49ad621c4af0/trio-0.22.2.tar.gz"
    sha256 "3887cf18c8bcc894433420305468388dac76932e9668afa1c49aa3806b6accb3"
  end

  resource "trio-websocket" do
    url "https://files.pythonhosted.org/packages/b2/9e/a529b1bb6289e252112c96929380d93a59c084bea90707701b9e7ee1af59/trio-websocket-0.10.4.tar.gz"
    sha256 "e66b3db3e2453017431dfbd352081006654e1241c2a6800dc2f43d7df54d55c5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/44/34/551f30cbdc0515c39c2e78ef5919615785cd370844e40ada82367c1fab3f/websocket-client-1.6.3.tar.gz"
    sha256 "3aad25d31284266bcfcfd1fd8a743f63282305a364b8d0948a43bd606acc652f"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    system "#{bin}/streamlink", "https://youtu.be/he2a4xK8ctk", "audio_mp4a", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MPEG v4 system", shell_output("file video.mp4")

    url = OS.mac? ? "https://ok.ru/video/3388934659879" : "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    output = shell_output("#{bin}/streamlink --ffmpeg-no-validation -l debug '#{url}'")
    assert_match "Available streams:", output
    refute_match "error", output
    refute_match "Could not find metadata", output
  end
end
