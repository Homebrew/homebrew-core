class Yewtube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/yewtube"
  url "https://github.com/mps-youtube/yewtube/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "012c1a8a185dd4ef81074631bca91e327ac4e634b36301a50ffbcd67838b847f"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/mps-youtube/yewtube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ea82ac26fb9703af32934e6b6ac71f7f5c9a178a0be897d238c507f9afeec5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ea82ac26fb9703af32934e6b6ac71f7f5c9a178a0be897d238c507f9afeec5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ea82ac26fb9703af32934e6b6ac71f7f5c9a178a0be897d238c507f9afeec5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ea82ac26fb9703af32934e6b6ac71f7f5c9a178a0be897d238c507f9afeec5e"
    sha256 cellar: :any_skip_relocation, ventura:       "7ea82ac26fb9703af32934e6b6ac71f7f5c9a178a0be897d238c507f9afeec5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf2ad3b093e73d86c4876171f925aafef56c81989ae951e8ca9192315bd22d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf2ad3b093e73d86c4876171f925aafef56c81989ae951e8ca9192315bd22d2"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "mplayer"
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pylast" do
    url "https://files.pythonhosted.org/packages/44/f1/bfd2cc8d67fcc0870e729e1e223fe0359ef94c9b9b98fdb78710d523464c/pylast-5.5.0.tar.gz"
    sha256 "b6e95cf11fb99779cd451afd5dd68c4036c44f88733cf2346ba27317c1869da4"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "youtube-search-python" do
    url "https://files.pythonhosted.org/packages/91/3c/dc669b0308e49f294df67bddbb16ff3eefe5b5da6fa37ead922a8301926b/youtube-search-python-1.6.6.tar.gz"
    sha256 "4568d1d769ecd7eb4bb8365f04eec6e364c5f70eec7b3765f543daebb135fcf5"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/b7/fb/588a23e61586960273524d3aa726bd148116d422854f727f4d59c254cb6a/yt_dlp-2025.6.9.tar.gz"
    sha256 "751f53a3b61353522bf805fa30bbcbd16666126537e39706eab4f8c368f111ac"
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
    console = fork do
      assert_match "checkupdate set to False", shell_output("#{bin}/yt set checkupdate false")
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
