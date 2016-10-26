class Weboob < Formula
  include Language::Python::Virtualenv

  desc "Web Outside of Browsers"
  homepage "http://weboob.org/"
  url "https://symlink.me/attachments/download/324/weboob-1.1.tar.gz"
  sha256 "cbc0d8a88e402ec71a79f0cf09594fd3a969122111f5cd695f4a4ca67961661c"
  revision 2
  head "https://git.symlink.me/pub/weboob/stable.git"

  bottle do
    cellar :any
    sha256 "e6f5e2b71675be9a72878e215b6fb1580812c186beb9c79e82f76c42c5313553" => :sierra
    sha256 "4255cec46b5b13ef3a1f10c0fcc5aeb0914e26d285c8c5f766c0a0ade45b2333" => :el_capitan
    sha256 "efc32ddd784885400c295ce6b75e753575c0ad558a7283fd02cb2ecc58baeb38" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libyaml"
  depends_on :gpg => :run

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/46/4f/94f6165052774839b4a4af0c72071aa528d5dc8cb8bc6bb43e24a55c10cc/Pillow-3.4.2.tar.gz"
    sha256 "0ee9975c05602e755ff5000232e0335ba30d507f6261922a658ee11b1cec36d1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "feedparser" do
    url "https://files.pythonhosted.org/packages/91/d8/7d37fec71ff7c9dbcdd80d2b48bcdd86d6af502156fc93846fb0102cb2c4/feedparser-5.2.1.tar.bz2"
    sha256 "ce875495c90ebd74b179855449040003a1beb40cd13d5f037a0654251e260b02"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "gdata" do
    url "https://files.pythonhosted.org/packages/a8/70/bd554151443fe9e89d9a934a7891aaffc63b9cb5c7d608972919a002c03c/gdata-2.0.18.tar.gz"
    sha256 "56e7d22de819c22b13ceb0fe1869729b4287f89ebbd4bb55380d7bcf61a1fdb6"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/4f/3f/cf6daac551fc36cddafa1a71ed48ea5fd642e5feabd3a0d83b8c3dfd0cb4/lxml-3.6.4.tar.gz"
    sha256 "61d5d3e00b5821e6cda099b3b4ccfea4527bf7c595e0fb3a7a760490cedd6172"
  end

  resource "mechanize" do
    url "https://files.pythonhosted.org/packages/32/bc/d5b44fe4a3b5079f035240a7c76bd0c71a60c6082f4bfcb1c7585604aa35/mechanize-0.2.5.tar.gz"
    sha256 "2e67b20d107b30c00ad814891a095048c35d9d8cb9541801cebe85684cc84766"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/c7/21/8911c1b4aab57b891a54bcb6b1fab2ef59e80a78f7f699dd3d162ddda87f/prettytable-0.7.tar.bz2"
    sha256 "bd3ee580540e80a90f463d6f83178aaa5c9900f310c65ad550e4bb116ffc8a16"
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
    venv = virtualenv_create(libexec)

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS::CLT.installed? ? "" : MacOS.sdk_path
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      ENV.delete "SDKROOT"
      ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["Pillow"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"weboob-config", "update"
    system bin/"weboob-config", "applications"
  end
end
