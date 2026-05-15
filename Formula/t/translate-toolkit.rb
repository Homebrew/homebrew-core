class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/fc/7a/36cc8e9c688febb9490945e844a0863b68931ed21ed7e77d3e5748dfffed/translate_toolkit-3.19.9.tar.gz"
  sha256 "b4e12ddf809b32aa9c051ee747ee1a912714e933d297487d3df2525c51a31739"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed56ca0a3ca3a886b4ab58bf4804f2f641d458693220aca4bb277c193af4d412"
    sha256 cellar: :any,                 arm64_sequoia: "90581ca2229279b222761ef498dff4f53fb5118d663e307ada8f9adffe29bb24"
    sha256 cellar: :any,                 arm64_sonoma:  "1cace7d8f9343ea3228f5a7a75dedd3f920ca22a08492fb3da917e587666b9c7"
    sha256 cellar: :any,                 sonoma:        "117dc84b6f64cc0620e09935c8b4644ff11e2ee5fa87040f926859d1b05dc0a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a8d7e3f6b324a8adace8acd88f35409ed90355b13d2b6deac35a6ab2ef2329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2698e8c072295a83228bf60f2399f574a94ec209dc2107ea5fc5d69e7c66cac2"
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
