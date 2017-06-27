class S3cmd < Formula
  desc "Command-line tool for the Amazon S3 service"
  homepage "http://s3tools.org/s3cmd"
  url "https://downloads.sourceforge.net/project/s3tools/s3cmd/2.0.0/s3cmd-2.0.0.tar.gz"
  sha256 "bf2a50802f1031cba83e99be488965803899d8ab0228c800c833b55c7269cd48"
  head "https://github.com/s3tools/s3cmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "434e855e0336c46ae7f5c6b1b9de49e7e37e9f387d236748a9c944a7a0693252" => :sierra
    sha256 "e3e3af32a6792e1a465b0f6b36370d9f922fb77ff4d8ef985aa18a4dc7e119d0" => :el_capitan
    sha256 "5d3ca9b0e3ce3eb11c2ac58d4e3aab0e3ffe5720f73592ae7e367231d2baf55e" => :yosemite
    sha256 "785afccd60cede060711520dd71dc41ca9298dc8091e55f0dc80eb7ee6a2f6dc" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/65/0b/c6b31f686420420b5a16b24a722fe980724b28d76f65601c9bc324f08d02/python-magic-0.4.13.tar.gz"
    sha256 "604eace6f665809bebbb07070508dfa8cabb2d7cb05be9a56706c60f864f1289"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    system bin/"s3cmd", "--help"
  end
end
