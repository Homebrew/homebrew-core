class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a0/64/882e8fc266228bd2290871ea041f80ec41f348bc605dd1c2989f26cc5407/trafilatura-2.4.0.tar.gz"
  sha256 "79e7e025fd18c14ffe6899549b61516827a53a06e1d82bdac7127202667a5561"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77a6011c5f679152a505a87bad6de8f592222b997bcc8030e69d03a64a183506"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02384a585e5bc23d663504df1739f03376e310bea431e976239f8771f4c0c0b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd665903a089e5ff141399c2bd81e083bb98301af976a8d7ec6e9263324e8750"
    sha256 cellar: :any,                 arm64_linux:       "49fc8b15450adf1e5e9d12e043604fe41a7a7e678a10a8129456d8568fa9edd2"
    sha256 cellar: :any,                 x86_64_linux:      "3416f7f73e499e63d1bd227f02b36a06b396f40ca3cca6d782697ad8ec3a29fb"
  end

  depends_on "certifi"
  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/c2/c3/cae6d3bdefd96a941ffc247c714ac4babc488a69012e11c058f6c17c6c47/charset_normalizer-3.5.3.tar.gz"
    sha256 "a250888753faa289e2997962fbb17c4960cbdb58575533ca6fceee68c224bdff"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/7b/24/24d78cee217be9435ebc246009524f0372d1aa86b01714d06e753671a0f1/courlan-1.5.0.tar.gz"
    sha256 "68adfdef9eed04240ce081d4fc9faf796db0e820795e9cc545b822aed8d26fc0"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/89/d9/d15e289b14dd41758bcc89ad41cab96647ed221e7d4fa8b0dc27bf089740/dateparser-1.5.1.tar.gz"
    sha256 "1c3d4a568b4f4d615adfc2945b54596adffc14f955c9b435030b5236226a4366"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/44/4d/3303caa82c75cd81e43d81906fa0f57c02c1e2e92ef9a3709cfe57fa678a/htmldate-1.11.0.tar.gz"
    sha256 "e099a58143d5ff32471f2aa8770247e12f0f5bdff62f2df74f833277fd0071b6"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f5/b0/168030b0bfcc334cf09fa3313afdb888d892c8a0027324683d1de0ec277e/pytz-2026.6.tar.gz"
    sha256 "3b0fc2727707663d6e517936f444fd8a8b240f1fc32f4bf7ee03274245945284"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b8/17/ef8c46a9e7cf2304968eb260f594bbd4220fab6281e64c090cdd85884511/regex-2026.11.19.tar.gz"
    sha256 "2826a006b68acfd3ed5074433caafe21d7f9d026eb82cb856724a4a893a70915"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/d8/89/2bd035df331499589fc92e59375c17c6cea6a500453b2c5f6a6ec9572825/tzlocal-5.4.5.tar.gz"
    sha256 "ba976898bad27945178c9ca25c222c19e322b30c10342b9f40b46714f70d2d5f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end
