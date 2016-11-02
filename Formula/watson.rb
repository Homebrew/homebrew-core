class Watson < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to track (your) time"
  homepage "https://tailordev.github.io/Watson/"
  url "https://files.pythonhosted.org/packages/e9/23/76b5770d759d6cd6865721cd83ff1f2df0c30212f2b22f4769a75c2b0b47/td-watson-1.4.0.tar.gz"
  sha256 "189ec0be843a07e6978586f4b802c97f82e08e6a5ac9631bc0bb4a901279c0df"
  head "https://github.com/TailorDev/Watson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b741a56ca9e59f9f52956854fb4c9225b2f127ccf02a97ee0a890b39353f7e2c" => :sierra
    sha256 "b28bfbdc75e530760733360be2c40f0a02c2ef6a3c31f5665779903786a1e92e" => :el_capitan
    sha256 "edb07d1e281f0a359c12c12a74402640499402037c7acc82da9c29d4781af605" => :yosemite
    sha256 "5e57982340da15e3e58642c7be8f3f9d3b9239f8433bf8bf680a968efc050cd8" => :mavericks
  end

  depends_on :python

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/58/91/21d65af4899adbcb4158c8f0def8ce1a6d18ddcd8bbb3f5a3800f03b9308/arrow-0.8.0.tar.gz"
    sha256 "b210c17d6bb850011700b9f54c1ca0eaf8cbbd441f156f0cd292e1fbda84e7af"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/watson", "start", "foo", "+bar"
    system "#{bin}/watson", "status"
    system "#{bin}/watson", "stop"
    system "#{bin}/watson", "log"
  end
end
