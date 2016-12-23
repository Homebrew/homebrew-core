class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/0.14.2.tar.gz"
    sha256 "6c17aaed61bcf46a9bd19218cbf2ec424504fafeb0a7d563a88d954ef27fa091"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/0.14.1.tar.gz"
      sha256 "2bd2f42f4c3144c2834e96e3e0d4ad2f158ee2a8655f2ba649b7aa41c8840baa"
    end

    resource "openssl" do
      url "https://github.com/PeterMosmans/openssl.git",
          :revision => "2622e9bff72f4949c285f2d955c2f78663d79776"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0b6a7883db808474b04b5a7a2c317df6866bcb88ddad7295d91c117f2e9049cc" => :sierra
    sha256 "1d4a1a965ae153fb499afb97c80d8522171f406711e202196c21b3949edc8c57" => :el_capitan
    sha256 "608d456eed12d684041f46a45f7210300c60ba3adc1639f65d41578538efa192" => :yosemite
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

  resource "zlib" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/z/zlib/zlib_1.2.8.dfsg.orig.tar.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/z/zlib/zlib_1.2.8.dfsg.orig.tar.gz"
    version "1.2.8"
    sha256 "2caecc2c3f1ef8b87b8f72b128a03e61c307e8c14f5ec9b422ef7914ba75cf9f"
  end

  def install
    venv = virtualenv_create(libexec)
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

    ENV.prepend "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", "run_tests.py"
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
  end
end
