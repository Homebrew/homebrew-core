class S3cmd < Formula
  desc "Command-line tool for the Amazon S3 service"
  homepage "http://s3tools.org/s3cmd"
  url "https://downloads.sourceforge.net/project/s3tools/s3cmd/2.0.1/s3cmd-2.0.1.tar.gz"
  sha256 "caf09f1473301c442fba6431c983c361c9af8bde503dac0953f0d2f8f2c53c8f"
  head "https://github.com/s3tools/s3cmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a549ae2ffe3d604c94d92c4b5028de1053ce654dfd690b717549afbee5d8952" => :high_sierra
    sha256 "5b768bdb9e81752dafd0f7d0bbffb349a663665322dee8659d5150b74b849a51" => :sierra
    sha256 "10ece7a8b1360bd8c0360cadb104dd071728622c2889bbd5acaf389ff899bab1" => :el_capitan
    sha256 "10ece7a8b1360bd8c0360cadb104dd071728622c2889bbd5acaf389ff899bab1" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/65/0b/c6b31f686420420b5a16b24a722fe980724b28d76f65601c9bc324f08d02/python-magic-0.4.13.tar.gz"
    sha256 "604eace6f665809bebbb07070508dfa8cabb2d7cb05be9a56706c60f864f1289"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
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
