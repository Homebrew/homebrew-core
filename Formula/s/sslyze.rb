class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/13/00/bacbb04d7d3e0d7db3cedec0b7a450a6ee9543aa4929b020a329f184daae/sslyze-5.1.3.tar.gz"
    sha256 "247eeed21e57cb5bfe8bd5565f83a35988cfad5c8294120fa7b729bd5e5cf949"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/refs/tags/5.0.1.tar.gz"
      sha256 "53302410923e5c1afd54c7f48051f15459eeacbd7005b719d2a5db12ede83042"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4b78c64baa9288800f6d3724d61680822215ac119c914fcfe88d0d07cb42e96b"
    sha256 cellar: :any,                 arm64_monterey: "2bce9a22e71eca7501b53978f4c790bfe0ea918bc769815fc39db0c913949766"
    sha256 cellar: :any,                 arm64_big_sur:  "e6db8bf038025808d83b3e44957fc1c7ae5b613b26f375181287c824c5409b35"
    sha256 cellar: :any,                 ventura:        "cfe2b486e6dc00fc6afa98f69eb7a077cff149589f049bfb452c3b43d2d9fbb3"
    sha256 cellar: :any,                 monterey:       "8a99c6e0c67b86b0e7095bc09253aab161e467be036c7803c2bf109922876baf"
    sha256 cellar: :any,                 big_sur:        "c4ea5beb7f8ddfaf0f563f7f9e2015d75f475547af1aaccc79d69cf6422b09fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31a88b8fcedda31ee10e6d6ab51f1693187fcecb929331896d28b64241aa73ac"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git", branch: "release"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git", branch: "release"
    end
  end

  # Original deprecation date: 2023-10-24
  disable! date: "2024-04-05", because: "uses deprecated `openssl@1.1`"

  depends_on "pyinvoke" => :build
  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  uses_from_macos "libffi", since: :catalina

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/f3/f4b8c175ea9a1de650b0085858059050b7953a93d66c97ed89b93b232996/cryptography-39.0.2.tar.gz"
    sha256 "bc5b871e977c8ee5a1bbc42fa8d19bcc08baf0c51cbf1586b0e87a2694dde42f"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/8b/87/200171b36005368bc4c114f01cb9e8ae2a3f3325a47da8c710cc58cfd00c/pydantic-1.10.6.tar.gz"
    sha256 "cf95adb0d1671fc38d8c43dd921ad5814a735e7d9b4d9e437c088002863854fd"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/af/6e/0706d5e0eac08fcff586366f5198c9bf0a8b46f0f45b1858324e0d94c295/pyOpenSSL-23.0.0.tar.gz"
    sha256 "c1cc5f86bcacefc84dada7d31175cae1b1518d5f60d3d0bb595a67822a868a6f"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/12/fc/282d5dd9e90d3263e759b0dfddd63f8e69760617a56b49ea4882f40a5fc5/tls_parser-2.0.0.tar.gz"
    sha256 "3beccf892b0b18f55f7a9a48e3defecd1abe4674001348104823ff42f4cbc06b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources.reject { |r| r.name == "nassl" }

    ENV.prepend_path "PATH", libexec/"bin"
    resource("nassl").stage do
      system "invoke", "build.all"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCANS COMPLETED", shell_output("#{bin}/sslyze --mozilla_config=old google.com")
    refute_match("exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org"))
  end
end
