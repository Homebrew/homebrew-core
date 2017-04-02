class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/1.0.0.tar.gz"
    sha256 "5117f10cda0d041816ebef78dc73fcb0ba16e4f3fe2a9a28f7a73eadbab2b921"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/0.15.1.tar.gz"
      sha256 "b25020074d0838837531b2ed30635ec715f60e13f11f416a89588edd08653f1f"
    end

    resource "openssl" do
      url "https://github.com/PeterMosmans/openssl.git",
          :revision => "2622e9bff72f4949c285f2d955c2f78663d79776"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d200e3d39344be2cebc3b0ffdaec99ea63c57e6cc7104b2b1128b7d6d91d91bd" => :sierra
    sha256 "4a7dad0da43827483982171fc1fc8b5e90581dc093668c13960fd9adddbb1b80" => :el_capitan
    sha256 "cd77953720ef441f9981e890f04ebb3b0990bf77de1d08ed943446df8e1c41a5" => :yosemite
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end

    resource "openssl" do
      url "https://github.com/PeterMosmans/openssl.git",
          :branch => "1.0.2-chacha"
    end
  end

  depends_on :arch => :x86_64
  depends_on :python if MacOS.version <= :snow_leopard

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/b6/0c/53c42edca789378b8c05a5496e689f44e5dd82bc6861d1ae5a926ee51b84/typing-3.5.3.0.tar.gz"
    sha256 "ca2daac7e393e8ee86e9140cd0cf0172ff6bb50ebdf0b06281770f98f31bff21"
  end

  resource "zlib" do
    url "http://zlib.net/zlib-1.2.11.tar.gz"
    mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz"
    sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
  end

  def install
    venv = virtualenv_create(libexec)

    venv.pip_install resource("enum34")
    venv.pip_install resource("typing")

    ENV.prepend_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resource("nassl").stage do
      nassl_path = Pathname.pwd
      # openssl fails on parallel build. Related issues:
      # - https://rt.openssl.org/Ticket/Display.html?id=3736&user=guest&pass=guest
      # - https://rt.openssl.org/Ticket/Display.html?id=3737&user=guest&pass=guest
      ENV.deparallelize do
        mv "bin/openssl/include", "nassl_openssl_include"
        rm_rf "bin" # make sure we don't use the prebuilt binaries
        (nassl_path/"bin/openssl").install "nassl_openssl_include" => "include"
        (nassl_path/"zlib-#{resource("zlib").version}").install resource("zlib")
        (nassl_path/"openssl").install resource("openssl")
        system "python", "build_from_scratch.py"
      end
      system "python", "run_tests.py"
      venv.pip_install nassl_path
    end
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
  end
end
