class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/1.2.0.tar.gz"
    sha256 "8dc5b3fa48e447ac6f878cf1c443ccd472616a6b0054961b390efb5e36614fa4"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/1.0.1.tar.gz"
      sha256 "fee22bcf94a869a8429432d31fd14cebe0cb426f43529065fc1de854ffa3fb92"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d874c02005937cae638bff1ae8053b55a05934d6fa621651bd58abf6f48888dd" => :high_sierra
    sha256 "297faa9579c3a2a5763217409bf82c90756b78f74342ceb8410bcc5fcc953823" => :sierra
    sha256 "3a0dae28db1f3ec22daca06e42192a7850567fa790bb55109b4183cd623fef0d" => :el_capitan
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on :arch => :x86_64
  depends_on :python if MacOS.version <= :snow_leopard

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/31/53/8bca924b30cb79d6d70dbab6a99e8731d1e4dd3b090b7f3d8412a8d8ffbc/asn1crypto-0.23.0.tar.gz"
    sha256 "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
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
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/a3/77/6e917d656fa2b017011347a1dd0a840c2247cb9c48fa6853104626435273/tls_parser-1.1.1.tar.gz"
    sha256 "e2406578f14c57dde82c8e410c30e6ebf85acda16a0fdcf1b965e574b3681c4e"
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

  resource "openssl-legacy" do
    url "https://ftp.openssl.org/source/old/1.0.2/openssl-1.0.2e.tar.gz"
    sha256 "e23ccafdb75cfcde782da0151731aa2185195ac745eea3846133f2e05c0e0bff"
  end

  resource "openssl-modern" do
    url "https://github.com/openssl/openssl.git",
        :branch => "tls1.3-draft-18"
  end

  def install
    venv = virtualenv_create(libexec)

    res = resources.map(&:name).to_set
    res -= %w[cryptography nassl openssl-legacy openssl-modern zlib]

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
        mv "bin/openssl-legacy/include", "nassl_openssl_legacy_include"
        mv "bin/openssl-modern/include", "nassl_openssl_modern_include"
        rm_rf "bin" # make sure we don't use the prebuilt binaries
        (nassl_path/"bin/openssl-legacy").mkpath
        (nassl_path/"bin/openssl-modern").mkpath
        mv "nassl_openssl_legacy_include", "bin/openssl-legacy/include"
        mv "nassl_openssl_modern_include", "bin/openssl-modern/include"
        (nassl_path/"zlib-#{resource("zlib").version}").install resource("zlib")
        (nassl_path/"openssl-1.0.2e").install resource("openssl-legacy")
        (nassl_path/"openssl-tls1.3-draft-18").install resource("openssl-modern")
        system "python", "build_from_scratch.py"
      end
      system "python", "run_tests.py"
      venv.pip_install nassl_path
      ENV.prepend "CPPFLAGS", "-I#{nassl_path}/openssl-tls1.3-draft-18/include"
      ENV.prepend "LDFLAGS", "-L#{nassl_path}/openssl-tls1.3-draft-18"
      venv.pip_install resource("cryptography")
    end
    venv.pip_install_and_link buildpath
    system "python", "run_tests.py"
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
  end
end
