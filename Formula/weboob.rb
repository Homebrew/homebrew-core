class Weboob < Formula
  include Language::Python::Virtualenv

  desc "Web Outside of Browsers"
  homepage "https://weboob.org/"
  url "https://git.weboob.org/weboob/weboob/uploads/7b91875f693b60e93c5976daa051034b/weboob-2.0.tar.gz"
  mirror "https://files.pythonhosted.org/packages/88/c1/b3423348d8e2a557c7e0d53b5977cf1a382703c7b4d1397876836184b493/weboob-2.0.tar.gz"
  sha256 "fc8be1f77ad3a53285cef8b20a8b747960c163fad729c56838043d8ddcdfc9b0"
  revision 1

  bottle do
    cellar :any
    sha256 "f49dd148a7cd73c2ffbb6fb64e9773a203496bf97217075faf1648586a681bf5" => :catalina
    sha256 "4b785a21dc030168621d99d92c31a8efc18291e672333e37602676c57707af64" => :mojave
    sha256 "4d0d91166a5486fa5b732c30b80900a5940b85ec2cee7f061ef0fa52f131a790" => :high_sierra
  end

  depends_on "freetype"
  depends_on "gnupg"
  depends_on "jpeg"
  depends_on "libyaml"
  depends_on "python@3.8"

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/34/18/8706cfa5b2c73f5a549fdc0ef2e24db71812a2685959cff31cbdfc010136/Babel-2.8.0.tar.gz"
    sha256 "1aac2ae2d0d8ea368fa90906567f5c08463d98ade155c0c4bfedd6a0f7160e38"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/6c/f9/033a17d8ea8181aee41f20c74c3b20f1ccbefbbc3f7cd24e3692de99fb25/html2text-2020.1.16.tar.gz"
    sha256 "e296318e16b059ddb97f7a8a1d6a5c1d7af4544049a01e261731d2d5cc277bbb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/39/2b/0a66d5436f237aff76b91e68b4d8c041d145ad0a2cdeefe2c42f76ba2857/lxml-4.5.0.tar.gz"
    sha256 "8620ce80f50d023d414183bf90cc2576c2837b88e00bea3f33ad2630133bbb60"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/ce/ef/e793f6ffe245c960c42492d0bb50f8d14e2ba223f1922a5c3c81569cec44/Pillow-7.1.2.tar.gz"
    sha256 "a0b49960110bc6ff5fead46013bcb8825d101026d466f3a4de3476defe0fb0dd"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/b1/d6/7e2a98e98c43cf11406de6097e2656d31559f788e9210326ce6544bd7d40/Unidecode-1.1.1.tar.gz"
    sha256 "2b6aab710c2a1647e928e36d69c21e76b453cd455f4e2621000e54b2a9b8cce8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  def install
    venv = virtualenv_create(libexec, "python3.8")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "xcb.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None",
                "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None",
                "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None",
                "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', " \
                                 "'#{Formula["freetype"].opt_prefix}/include')"
      end

      unless MacOS::CLT.installed?
        ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
      venv.pip_install Pathname.pwd
    end

    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    res = resources.map(&:name).to_set - ["Pillow"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"weboob-config", "modules"
  end
end
