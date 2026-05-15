class Scdl < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to download music from SoundCloud"
  homepage "https://github.com/scdl-org/scdl"
  url "https://files.pythonhosted.org/packages/29/68/602ea370bb383a043f577787a4bbfd9f4e193ffcbe1a7b6325e37f126a08/scdl-3.0.4.tar.gz"
  sha256 "afb72fb28293584d16fe96e399b686aab6bdfaa6f5303c5fd81e42feb76b09d5"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/scdl-org/scdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bedf56a49242445e29dd8532b82072961600aef585880c60af3b2dbce4afdd06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaabc5d3ed7fdc4674f318026b78089b7f6d506ab777ae096a4b39af2008c4c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a44b9ca4cba3a884df506e0ccd0819e48dadce74b24272a1f4a02564597bdc2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5261a07cecbd1bd2fc7487731a95447856a2e7138c64ba63797e182597807a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b06207959802c04b92bba716e86931905afe82e9590e4cd59d0b4916e8f9191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "579f7ee9d57f8738215fb8e10cc0859f129b2b52d97cf5149f9c28adf477c42e"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "ffmpeg"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cffi]

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/48/5b/89fcfebd3e5e85134147ac99e9f2b2271165fd4d71984fc65da5f17819b7/curl_cffi-0.15.0.tar.gz"
    sha256 "ea0c67652bf6893d34ee0f82c944f37e488f6147e9421bef1771cc6545b02ded"
  end

  resource "dacite" do
    url "https://files.pythonhosted.org/packages/55/a0/7ca79796e799a3e782045d29bf052b5cde7439a2bbb17f15ff44f7aacc63/dacite-1.9.2.tar.gz"
    sha256 "6ccc3b299727c7aa17582f0021f6ae14d5de47c7227932c47fec4cdfefd26f09"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soundcloud-v2" do
    url "https://files.pythonhosted.org/packages/f1/87/abf8b9f9075c908b4433ee31ca856f9be068dc4315a71e05e9a384ba3a1f/soundcloud_v2-1.7.0.tar.gz"
    sha256 "ce6789f5d7966c38939d52c7fcb326197592c06d68d5585859fa0a4f98c095c9"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/8b/34/7c6b4e3f89cb6416d2cd7ab6dab141a1df97ab0fb22d15816db2c92148c9/yt_dlp-2026.3.17.tar.gz"
    sha256 "ba7aa31d533f1ffccfe70e421596d7ca8ff0bf1398dc6bb658b7d9dec057d2c9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scdl --version").chomp

    output = shell_output("#{bin}/scdl -l https://soundcloud.com/forss/city-ports 2>&1")
    assert_match "[download] Destination: #{testpath}/[290] Forss - City Ports.m4a", output
    assert_match "[download] 100%", output
  end
end
