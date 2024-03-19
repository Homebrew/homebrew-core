class Unoconv < Formula
  include Language::Python::Virtualenv

  desc "Convert between any document format supported by OpenOffice"
  homepage "https://github.com/unoconv/unoconv"
  url "https://files.pythonhosted.org/packages/ab/40/b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9ae/unoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/unoconv/unoconv.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46d798d1253d462f0b66dfe55f375beb596ee595e8e7a402ff58d3e47ebd5ca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e451f76bd673895575c591de796dbf8dbd59c151b82b13a2c08a748ad84ca44b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52c246ad03f649c5d52cfedb723fae1ed5707f8604be16fee43a37b5f28bca2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5652ef379b6c4579c2b1735ac961b40e3d1b247260982860c22b4394561494a1"
    sha256 cellar: :any_skip_relocation, ventura:        "9d41182735fcf0e317a2ac3f7340ec27f2e29eac13c3e1614aad04920c03568c"
    sha256 cellar: :any_skip_relocation, monterey:       "f81e96570ca29923b45c303ecfeea9d39af101d6f3e6fd101b8374111c25b1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "430c2bfdd0d1a633f425ec2893d942d8157b0b0f7dded2310fa671ca223e63a8"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  def install
    virtualenv_install_with_resources
    man1.install "doc/unoconv.1"
  end

  def caveats
    <<~EOS
      In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
    EOS
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoconv 2>&1")
  end
end
