class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://files.pythonhosted.org/packages/a4/1d/c3d998c9e9fb85395eef7fc1f340f6759c7396e8f5eb3f3daba5ceb93642/streamlink-5.1.2.tar.gz"
  sha256 "501f604d3dbfad05d5d50ed4432c041e51810890cc0e65eea43f27608238767a"
  license "BSD-2-Clause"
  head "https://github.com/streamlink/streamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c70bf73e06817a3924dea8c5ccf6e985b209679fa5833fb3828cbd604922cb31"
    sha256 cellar: :any,                 arm64_monterey: "ea08fa134b6b13f661f12684307944660045d626a0f74e5b77bf7963eaf36562"
    sha256 cellar: :any,                 arm64_big_sur:  "ad1ebb0929e820ec70c6d6ccc02d5cc563e0eed799457a719747fec67666a1aa"
    sha256 cellar: :any,                 ventura:        "47e84563fc44d6f87978dcedf19dcd857371c77bde2cc5e60f1afdc3b412849d"
    sha256 cellar: :any,                 monterey:       "d00571b71bd35877f508f986d7b24baac043086de162b2160f5323c2676b2c34"
    sha256 cellar: :any,                 big_sur:        "f346636ef1a1dca74c6cb33c96281d350f5803a8188d9f759fafcd062c30d201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073bb7a89ecd4baa6d685797b356b5e7a8077b292f90f4095f0d2809d65dfb07"
  end

  depends_on "libxml2" # https://github.com/Homebrew/homebrew-core/issues/98468
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
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
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/33/24/033604d30f6cf82d661c0f9dfc2c71d52cafc2de516616f80d3b0600cb7c/pycountry-22.3.5.tar.gz"
    sha256 "b2163a246c585894d808f18783e19137cb70a0c18fb36748dc01fc6f109c1646"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/0d/66/5e4a14e91ffeac819e6888037771286bc1b86869f25d74d60bc4a61d2c1e/pycryptodome-3.16.0.tar.gz"
    sha256 "0e45d2d852a66ecfb904f090c3f87dc0dfb89a499570abad8590f10d9cffb350"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/75/af/1d13b93e7a21aca7f8ab8645fcfcfad21fc39716dc9dce5dc2a97f73ff78/websocket-client-1.4.2.tar.gz"
    sha256 "d6e8f90ca8e2dd4e8027c4561adeb9456b54044312dba655e7cae652ceb9ae59"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    system "#{bin}/streamlink", "https://youtu.be/he2a4xK8ctk", "360p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MP4 v2", shell_output("file video.mp4")

    url = OS.mac? ? "https://ok.ru/video/3388934659879" : "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    output = shell_output("#{bin}/streamlink -l debug '#{url}'")
    assert_match "Available streams:", output
    refute_match "error", output
    refute_match "Could not find metadata", output
  end
end
