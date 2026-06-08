class Scdl < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to download music from SoundCloud"
  homepage "https://github.com/scdl-org/scdl"
  url "https://files.pythonhosted.org/packages/a8/2f/147c9b5a90fea98e92409eb168bb3dab286d993c28ec46aff1a9750cde52/scdl-3.0.5.tar.gz"
  sha256 "2306c7d5851e26e01fdabb4a59f96eca4b1146451a6f450cb8e5803fc2fcaf31"
  license "GPL-2.0-only"
  head "https://github.com/scdl-org/scdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2933d6b9abf2ab57b2dcf34f2375da404d41671839907cae859a7c35fe5243e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0f7e8d7b73ba5e09d808559330a6f199455973390624f6cde56e7c3aa26745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f841cadf3cc1d0008435473cd9f3a6df633027ea60aa08b788f2eb069f69af0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4efced710942d08a7ad853d342ecb5ef60f4608ce217585ddda2d6f8b9e2e494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c16829e379f62feed329d21de20b43bbbad70dd56f6adcf178d5f4459dfe5f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe4b2d4ce21d0823ed102f14e39864a70d249c5dcd8cc7c0f37b197fe9a27708"
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

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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
