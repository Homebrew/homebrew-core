class Watson < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to track (your) time"
  homepage "https://tailordev.github.io/Watson/"
  url "https://files.pythonhosted.org/packages/e9/23/76b5770d759d6cd6865721cd83ff1f2df0c30212f2b22f4769a75c2b0b47/td-watson-1.4.0.tar.gz"
  sha256 "189ec0be843a07e6978586f4b802c97f82e08e6a5ac9631bc0bb4a901279c0df"
  head "https://github.com/TailorDev/Watson.git"

  bottle do
    rebuild 1
    sha256 "abd34fcb26af6dfedbd04309e1f89cdf344b22106230babc52cde7278ebf83fa" => :sierra
    sha256 "c442d3832a3fe7d1be02c4e164ffa2f0acfdb0037c973ed251c5c847bccdd28e" => :el_capitan
    sha256 "3903dade326956273ec9f34e00b105aa3bfd7ea92a33aa2a9b1c2a2b68b3cce1" => :yosemite
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

    bash_completion.install "watson.completion" => "watson"
    zsh_completion.install "watson.zsh-completion" => "_watson"
  end

  test do
    system "#{bin}/watson", "start", "foo", "+bar"
    system "#{bin}/watson", "status"
    system "#{bin}/watson", "stop"
    system "#{bin}/watson", "log"
  end
end
