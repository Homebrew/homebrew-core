class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/2.0.0.tar.gz"
    sha256 "cda81b4a1a9776cb3153377b3d1be4d0ce0064c9222c84f7d7b7795372b6dbb4"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/2.1.0.tar.gz"
      sha256 "3008c445966da6cd159f185264aec17eefaa25a3515e58d69887489efdf5a35e"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "75cedd2004b9268d5abac35bf71be4205955221a6dc9aeeee65fc934cffe7b0f" => :mojave
    sha256 "c84dcbe2c30a40bfcd36cafc7418c8842435bf81aa9bbd82a18286892d76b3a5" => :high_sierra
    sha256 "f65561a05b88c4561c00c024fcecd1def2f5ba65a92875255342ca601732a38f" => :sierra
    sha256 "ce82f4e5b63f2893b81f9d95cea808cb340a973fab0a0510346cd4a4156190a1" => :el_capitan
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on :arch => :x86_64
  depends_on "python"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/79/a2/61c8625f96c8582d3053f89368c483ba62e56233d055e58e372f94a393f0/cryptography-2.3.tar.gz"
    sha256 "c132bab45d4bd0fff1d3fe294d92b0a6eb8404e93337b3127bdec9f21de117e6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
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
    url "https://files.pythonhosted.org/packages/49/c4/aa379256eb83469154c671b700b3edb42ae781044a4cd40ae92bff8259c7/tls_parser-1.2.1.tar.gz"
    sha256 "869ad3c8a45e73bcbb3bf0dd094f0345675c830e851576f42585af1a60c2b0e5"
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
        :revision => "354e010757b95d27fb36d364412ee7a5e7111963"
  end

  def install
    venv = virtualenv_create(libexec)

    res = resources.map(&:name).to_set
    res -= %w[cryptography nassl openssl-legacy openssl-modern zlib]

    res.each do |r|
      venv.pip_install resource(r)
    end

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    if MacOS.sdk_path_if_needed
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi" # libffi
    end

    resource("nassl").stage do
      nassl_path = Pathname.pwd
      # openssl fails on parallel build. Related issues:
      # - https://rt.openssl.org/Ticket/Display.html?id=3736&user=guest&pass=guest
      # - https://rt.openssl.org/Ticket/Display.html?id=3737&user=guest&pass=guest
      ENV.deparallelize do
        mv "bin/openssl-legacy/include", "nassl_openssl_legacy_include"
        mv "bin/openssl-modern/include", "nassl_openssl_modern_include"
        rm_rf "bin" # make sure we don't use the prebuilt binaries
        (nassl_path/"bin/openssl-legacy/darwin64").mkpath
        (nassl_path/"bin/openssl-modern/darwin64").mkpath
        mv "nassl_openssl_legacy_include", "bin/openssl-legacy/include"
        mv "nassl_openssl_modern_include", "bin/openssl-modern/include"
        (nassl_path/"zlib-#{resource("zlib").version}").install resource("zlib")
        (nassl_path/"openssl-1.0.2e").install resource("openssl-legacy")
        (nassl_path/"openssl-master").install resource("openssl-modern")
        system "python3", "build_from_scratch.py"
      end
      system "python3", "run_tests.py"
      venv.pip_install nassl_path

      # Link cryptography against the openssl modern used by nassl above
      # Avoid "TypeError - object of type 'UnrecognizedExtension' has no len()"
      # Work around https://github.com/pyca/cryptography/issues/4373
      # See https://github.com/nabla-c0d3/sslyze/issues/323
      ENV.prepend "CPPFLAGS", "-I#{nassl_path}/bin/openssl-modern/include"
      ENV.prepend "LDFLAGS", "-L#{nassl_path}/bin/openssl-modern/darwin64"
      venv.pip_install resource("cryptography")
    end
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
    assert_no_match "exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org")
  end
end
