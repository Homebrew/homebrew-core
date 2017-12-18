class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/1.3.0.tar.gz"
    sha256 "fa78697f706c123ada3afa09c7210af4172fdba39580516390711f3548b9972d"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/1.0.2.tar.gz"
      sha256 "145c150d5ab852fb9efe24a32cbfab0ebd0036d1fd6ba8756f2f9d68dd2e7959"
    end
  end

  bottle do
    cellar :any
    sha256 "94e5edbbb3e7a4d2101c9f805b26280d9cc66c2dad2b9996278be531d8fc0628" => :high_sierra
    sha256 "7c7fa573a9629c3cab2f4efc4528ca3023d8deecd2dfd7886d9223f0ba36b1b8" => :sierra
    sha256 "1505e9c6e76c1fae4e66ee0f2e794aa92c74ef0cbd6dbf4768daaf0695f0f28b" => :el_capitan
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on :arch => :x86_64
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl@1.1"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/78/c5/7188f15a92413096c93053d5304718e1f6ba88b818357d05d19250ebff85/cryptography-2.1.4.tar.gz"
    sha256 "e4d967371c5b6b2e67855066471d844c5d52d210c36c28d49a8507b96e2c5291"
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
    url "https://files.pythonhosted.org/packages/f0/ba/860a4a3e283456d6b7e2ab39ce5cf11a3490ee1a363652ac50abf9f0f5df/ipaddress-1.0.19.tar.gz"
    sha256 "200d8686011d470b5e4de207d803445deee427455cd0cb7c982b68cf82524f81"
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
    url "https://files.pythonhosted.org/packages/e1/4b/e513b1fc7a75cdb9fffb3969598d978e586a7d01a90c8fbbe95be741a2b6/tls_parser-1.2.0.tar.gz"
    sha256 "c0c9de56a5aef2d56db18f23d0e29970974e6b53ec52e552404d3eca20f55ad6"
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
    res -= %w[nassl openssl-legacy openssl-modern zlib]

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
    end
    venv.pip_install_and_link buildpath
    system "python", "run_tests.py"
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
  end
end
