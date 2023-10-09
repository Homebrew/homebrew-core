class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/cb/b5/563fe54a44d00575aa5ada6f3342f094a550f10a07db66375ce81611ae83/svtplay-dl-4.26.tar.gz"
  sha256 "679494d281114a768e44dab88e96077ab4335c4c21a2e8f299bc8acfa21bd904"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62847a24367940a865cd71d6283b02dfcd5a591d9b436bb46858703d1d1538e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d143ce12eb6d2fdb3371745c6cae28afcc19a2094e247e544b322d863260cc57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c44bad8a1e700a933db5f771258045a4240d9f75c862ffc820873bfef002695e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f743a67c99786c3fd6f564ca5a868b623a1f3e8c25de1639fd72560bd7dbd24"
    sha256 cellar: :any_skip_relocation, ventura:        "8c7fb82fb4f6bf1f0f70866ce3aa42d69dc50cd7b6510739045bd9dd7612e76b"
    sha256 cellar: :any_skip_relocation, monterey:       "9d778912518bbf6c6b98c6f2ab462a471654fd7cf280109b96cb4ecbbdb70ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c24c3d8fc78e8e4c9919c54938172f24f323a9bd96a1d9b2f89452c0524b2f10"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
