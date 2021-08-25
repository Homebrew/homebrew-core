class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility"
  url "https://github.com/volatilityfoundation/volatility/archive/2.6.1.tar.gz"
  sha256 "a8dfdbdb2aaa0885387b709b821bb8250e698086fb32015bc2896ea55f359058"
  license "GPL-2.0"
  revision 2
  head "https://github.com/volatilityfoundation/volatility.git", branch: "master"

  bottle do
    sha256 cellar: :any, catalina:    "f41ce1f3f70a5bb1eab7efac3d74ace7dad7bdf581bcb16b7a09d34e27e38d50"
    sha256 cellar: :any, mojave:      "5bcfa94349a26dc291af274bcf3427851ed2654e36781d05e3774018ee8f7781"
    sha256 cellar: :any, high_sierra: "0d156b81c472080d117d567167d7a6d294376bab6d3c4751b4ca343a25fefa3d"
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on :macos # Due to Python 2 (Python 3 support will come with volatility 3)
  # https://github.com/volatilityfoundation/volatility3
  depends_on "yara"

  on_linux do
    depends_on "gmp"
  end

  resource "distorm3" do
    url "https://files.pythonhosted.org/packages/2c/e3/84a3a99904c368daa1de5e85a6e9cc07189e7f66cb1338a9ebf93fa051bd/distorm3-3.4.1.tar.gz"
    sha256 "0ed65741b31cc113f1c98641594fc3e24f0563b6977c5ea2a7d97983095caa0c"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/1d/93/688492dcedbd57a9c0b4074aa47d39ac5f5e7411a8ce69b23e57a801e638/yara-python-3.10.0.tar.gz"
    sha256 "2da1d94850cbea1dd9db1cc7d54bb36a69cd6a33bbc0caf003497b6a323e3e10"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/51/fe/18125dc680720e4c3086dd3f5f95d80057c41ab98326877fc7d3ff6d0ee5/Pillow-6.1.0.tar.gz"
    sha256 "0804f77cb1e9b6dbd37601cee11283bba39a8d44b9ddb053400c58e0c0d7d9de"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/ba/06/b899c8867518df19e242d8cbc82d4ba210f5ffbeebb7704c695e687ab59c/openpyxl-2.6.2.tar.gz"
    sha256 "1d2af392cef8c8227bd2ac3ebe3a28b25aba74fd4fa473ce106065f0b73bfe2e"
  end

  resource "et_xmlfile" do
    url "https://files.pythonhosted.org/packages/22/28/a99c42aea746e18382ad9fb36f64c1c1f04216f41797f2f0fa567da11388/et_xmlfile-1.0.1.tar.gz"
    sha256 "614d9722d572f6246302c4491846d2c393c199cfa4edc9af593437691683335b"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/7b/b0/fa20fce23e9c3b55b640e629cb5edf32a85e6af3cf7af599940eb0c753fe/jdcal-1.4.1.tar.gz"
    sha256 "472872e096eb8df219c23f2689fc336668bdb43d194094b5cc1707e1640acfc8"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/16/c4/79f3409bc710559015464e5f49b9879430d8f87498ecdc335899732e5377/ujson-1.35.tar.gz"
    sha256 "f66073e5506e91d204ab0c614a148d5aa938bdbf104751be66f8ad7a222f5f86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/df/d5/3e3ff673e8f3096921b3f1b79ce04b832e0100b4741573154b72b756a681/pytz-2019.1.tar.gz"
    sha256 "d747dd3d23d77ef44c6a3526e274af6efeb0a6f1afd5a69ba4d5be4098c8e141"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/41/a6/2d25314b1f9375639d8f8e0f8052e8cec5df511d3449f22c4f1c2d8cb3c6/ipython-5.8.0.tar.gz"
    sha256 "4bac649857611baaaf76bc82c173aa542f7486446c335fe1a6c05d0d491c8906"
  end

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/26/34/0f3a5efac31f27fabce64645f8c609de9d925fe2915304d1a40f544cff0e/appnope-0.1.0.tar.gz"
    sha256 "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71"
  end

  resource "backports.shutil_get_terminal_size" do
    url "https://files.pythonhosted.org/packages/ec/9c/368086faa9c016efce5da3e0e13ba392c9db79e3ab740b763fe28620b18b/backports.shutil_get_terminal_size-1.0.0.tar.gz"
    sha256 "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/ba/19/1119fe7b1e49b9c8a9f154c930060f37074ea2e8f9f6558efc2eeaa417a2/decorator-4.4.0.tar.gz"
    sha256 "86156361c50488b84a3f148056ea716ca587df2f0de1d34750d35c21312725de"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/b5/f4/9c7cc726ece2498b6c8b62d3262aa43f59039b953fe23c9964ac5e18d40b/pathlib2-2.3.4.tar.gz"
    sha256 "446014523bb9be5c28128c4d2a10ad6bb60769e78bd85658fe44a450674e0ef8"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/1c/b1/362a0d4235496cb42c33d1d8732b5e2c607b0129ad5fdd76f5a583b9fcb3/pexpect-4.7.0.tar.gz"
    sha256 "9e2c1fd0e6ee3a49b28f95d4b33bc389c89b20af6a1255906e90ff1262ce62eb"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/94/a0/57dc47115621d9b3fcc589848cdbcbb6c4c130186e8fc4c4704766a7a699/prompt_toolkit-2.0.9.tar.gz"
    sha256 "2519ad1d8038fd5fc8e770362237ad0364d16a7650fb5724af6997ed5515e3c1"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
    sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"
  end

  resource "simplegeneric" do
    url "https://files.pythonhosted.org/packages/3d/57/4d9c9e3ae9a255cd4e1106bb57e24056d3d0709fc01b2e3e345898e49d5b/simplegeneric-0.8.1.zip"
    sha256 "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/a5/98/7f5ef2fe9e9e071813aaf9cb91d1a732e0a68b6c44a32b38cb8e14c3f069/traitlets-4.3.2.tar.gz"
    sha256 "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    venv = virtualenv_create(libexec)

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.hi"

        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"

        jpeg_opt_prefix = Formula["jpeg"].opt_prefix
        s.gsub! "JPEG_ROOT = None",
                "JPEG_ROOT = ('#{jpeg_opt_prefix}/lib', '#{jpeg_opt_prefix}/include')"

        freetype_opt_prefix = Formula["freetype"].opt_prefix
        s.gsub! "FREETYPE_ROOT = None",
                "FREETYPE_ROOT = ('#{freetype_opt_prefix}/lib', '#{freetype_opt_prefix}/include')"
      end

      begin
        # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
        deleted = ENV.delete "SDKROOT"
        unless MacOS::CLT.installed?
          ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
        end
        venv.pip_install Pathname.pwd
      ensure
        ENV["SDKROOT"] = deleted
      end
    end

    res = resources.map(&:name).to_set - ["Pillow"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/vol.py", "--info"
  end
end
