class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ca/85/5829ec57c43b4bbace4981e1b26a719438cea4575e9e9019f8e8e03e9276/translate_toolkit-3.19.6.tar.gz"
  sha256 "966a7c459a8aba6a86e504b0532dc5f29ab8ca6e852e5f78f270eddd7c8b0e95"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8013ad7e5d514a9e45aa09475627d401135b5b774ffd3a112ab2e7bcce44e29"
    sha256 cellar: :any,                 arm64_sequoia: "56a55ec30ff894ede6df1ed1bb9e7e76998cd440c14923a7c21f38f77f3b0a56"
    sha256 cellar: :any,                 arm64_sonoma:  "d6e4b8aa85e8c05fd226a4e5dc9651d198f08bc340c5516ac97f72e3547bd1d0"
    sha256 cellar: :any,                 sonoma:        "5f5d7c3d349799fed24f872bd283c1c613cf78ae5ef55826b8f78532cc66fa2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edb2d89320c8b16eadfdecac1b3b5b5f627817fe91e42899972a5319d23cfb56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1e46fd61550c82f76f4fd02366c066b389c29eaa87145a98f3eff70f4c8047"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/15/cd/36adf321a9ba23906f44c1358164d6f69a149350c53802e366a270f7d82c/unicode_segmentation_rs-0.2.4.tar.gz"
    sha256 "d22f419787e77baeac966076d1bf09272cc1087bddfec14f74ce994437d3779d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
