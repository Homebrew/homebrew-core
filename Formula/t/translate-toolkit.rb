class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/65/89/4922b6580689b67977df95ba29dbfa339b83b62bf297a655f36201ed88c6/translate_toolkit-3.19.4.tar.gz"
  sha256 "584d1ec00a9bafe93fba22207622e87f63a846248b38385ee9021488d1763013"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fae436baebe485dd0ac7bc63c960fa7982e9b5a9669eedbf696b728b36166e09"
    sha256 cellar: :any,                 arm64_sequoia: "bed59f78f67071679673e9ae2194d0f7dbae864ee5686a5f2836f5b85d0fff5b"
    sha256 cellar: :any,                 arm64_sonoma:  "175ea4ea6bf6cf0870afc9755d489309a82d4450cd1f66dbd8e98b38c1cfab95"
    sha256 cellar: :any,                 sonoma:        "d8229a67dfd1bfb84b8aff48c1751d9285a703402e043144bb62ea8e079e4d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07d2785b6cda98c7e130f7114bb4bb68de4d2477adebc3320cd6a871b415ef30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc481ee0f45e4e5affb3ccaab3f0beb34b951aeb311e2eb234964cc87582c31"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/43/42/149c7747977db9d68faee960c1a3391eb25e94d4bb677f8e2df8328e4098/lxml-6.0.3.tar.gz"
    sha256 "a1664c5139755df44cab3834f4400b331b02205d62d3fdcb1554f63439bf3372"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/51/f1/a72fa6016d11a186830796b63bee66260be6dfe0a5f4c09f46f6d086fd07/unicode_segmentation_rs-0.2.2.tar.gz"
    sha256 "381fc095be217a6ba08384afbf115fa48735bed66e99a3f5c1130ab43508ef5b"
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
