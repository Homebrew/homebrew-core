class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/1.1.4.tar.gz"
    sha256 "ac47eb9de81f3af4d13d21c4a4e4d1d66cdf2cf6e663e52067bdc78e9757edfe"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/0.17.0.tar.gz"
      sha256 "1a5f07ae40372bc5522068bc7f8509eac0169bc1233fea823810948aa071bad8"
    end

    resource "openssl" do
      url "https://github.com/PeterMosmans/openssl.git",
          :revision => "c9ba19c8b7fd131137373dbd1fccd6a8bb0628be"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2ff8ec4c5b1b232b285ebdd27a786997d70ff1350f22aea451a327daff0ba5e0" => :sierra
    sha256 "6c19c297a4e1158a5ae177e7ae1721804dcd0f0ba0556e1f6301fa595177533c" => :el_capitan
    sha256 "f36ba5b8b4fbea611b994d1e0f29463b8d3331602668683ea8e71703fcd1a560" => :yosemite
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

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/2a/0c/31bd69469e90035381f0197b48bf71032991d9f07a7e444c311b4a23a3df/cryptography-1.9.tar.gz"
    sha256 "5518337022718029e367d982642f3e3523541e098ad671672a90b82474c84882"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/56/d9/6b048b9434b55acede2fd54c4db901ecab1b642d3e9248635be153afbe8a/tls_parser-1.1.0.tar.gz"
    sha256 "0652320987af8e8223e32d1b045f4d8f5cd1533b01cb90edab370eb358757df0"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/ca/38/16ba8d542e609997fdcd0214628421c971f8c395084085354b11ff4ac9c3/typing-3.6.2.tar.gz"
    sha256 "d514bd84b284dd3e844f0305ac07511f097e325171f6cc4a20878d11ad771849"
  end

  resource "zlib" do
    url "https://zlib.net/zlib-1.2.11.tar.gz"
    mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz"
    sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
  end

  def install
    venv = virtualenv_create(libexec)

    res = resources.map(&:name).to_set - %w[cryptography nassl openssl zlib]

    res.each do |r|
      venv.pip_install resource(r)
    end

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

        # Upstream issue "ocsp_response_tests.py intermittent failure"
        # Reported 22 Jul 2017 https://github.com/nabla-c0d3/nassl/issues/16
        inreplace "build_from_scratch.py",
          "perform_build_task('NASSL Tests', NASSL_TEST_TASKS)", ""

        system "python", "build_from_scratch.py"
      end
      venv.pip_install nassl_path
      ENV.prepend "CPPFLAGS", "-I#{nassl_path}/openssl/include"
      ENV.prepend "LDFLAGS", "-L#{nassl_path}/openssl"
      venv.pip_install resource("cryptography")
    end
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
  end
end
