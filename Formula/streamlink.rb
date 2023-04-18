class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://files.pythonhosted.org/packages/f7/02/0c1e470c69976555ba19209dbea022c1319fc299c46c8a10b98948240b15/streamlink-5.4.0.tar.gz"
  sha256 "d854348c19e032140d06ba13ee4d9b96fa838b979b689133dfd9bbdda474310b"
  license "BSD-2-Clause"
  head "https://github.com/streamlink/streamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d4c32eddefeb09cce6e8179f1ea37014e1fee8a6ba43c7b0a19590a53fe7637"
    sha256 cellar: :any,                 arm64_monterey: "69688c301794508319086d2c17f096bc73c8235f4d882a78a1b9ad97aa1756b2"
    sha256 cellar: :any,                 arm64_big_sur:  "ea03bd38ad77c6fc39aba9da6dcb8c041a553e1634186bda120efbd9eee93527"
    sha256 cellar: :any,                 ventura:        "1235c76e470e38a1178758de05c7c4e69b1ac7bf729c06d51f0dcdc29ff48bc1"
    sha256 cellar: :any,                 monterey:       "9327d8f902e93a7e7c8249bb4fc871e4677fd8cccfefe6ae0ebfa30cea80845a"
    sha256 cellar: :any,                 big_sur:        "118e980fe1b50d196455f57a0d547c70e7c473046e4b77cd604722c8f622ec71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f777e4352e29e2ab7aa76fd35ec37645d99e4b770b70ffaaa66330d7db7ff6b"
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
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
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
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/33/24/033604d30f6cf82d661c0f9dfc2c71d52cafc2de516616f80d3b0600cb7c/pycountry-22.3.5.tar.gz"
    sha256 "b2163a246c585894d808f18783e19137cb70a0c18fb36748dc01fc6f109c1646"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b8/2e/cf9cfd1ae6429381d3d9c14c8df79d91ae163929972f245a76058ea9d37d/pycryptodome-3.17.tar.gz"
    sha256 "bce2e2d8e82fcf972005652371a3e8731956a0c1fbb719cc897943b3695ad91b"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8b/94/696484b0c13234c91b316bc3d82d432f9b589a9ef09d016875a31c670b76/websocket-client-1.5.1.tar.gz"
    sha256 "3f09e6d8230892547132177f575a4e3e73cfdf06526e20cc02aa1c3b47184d40"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    system "#{bin}/streamlink", "https://youtu.be/he2a4xK8ctk", "360p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MP4 v2", shell_output("file video.mp4")

    url = OS.mac? ? "https://ok.ru/video/3388934659879" : "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    output = shell_output("#{bin}/streamlink --ffmpeg-no-validation -l debug '#{url}'")
    assert_match "Available streams:", output
    refute_match "error", output
    refute_match "Could not find metadata", output
  end
end
