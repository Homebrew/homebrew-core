class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/06/25/e3ebeefdebfdfae8c4a4396f5a6ea51fc6fa0831d63ce338e5090a8003dc/trafilatura-2.0.0.tar.gz"
  sha256 "ceb7094a6ecc97e72fea73c7dba36714c5c5b577b6470e4520dca893706d6247"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "505f84b8d24a77ceb6d76724565c4aa15328b1387e0ddfde87a559fe9fe5f3d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b3baf89879238df5adad51d5760dffd6d8b2037e46b324b2f16de6d7638c6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b553c17f86bafe9f26435dfd8cf62553edcacf246f60f2e3534b06430a519c2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6afd99392568f511f979a48743edee48540be464fc5e6c08ffd502afdc5bda5e"
    sha256 cellar: :any_skip_relocation, ventura:       "e01ee817069b9bae6800880153c0c7a9ff25eb02555f9968aa6a9edfc1024ced"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04e141a2de86a1dddef82a4200fb9388a9357fe8e02290831476ba38a16665f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6410979b76f70b9e8ca8786d708e7713212afb61d59231c497c2d9b97287a254"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/2a/74/f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9/babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/6f/54/6d6ceeff4bed42e7a10d6064d35ee43a810e7b3e8beb4abeae8cff4713ae/courlan-1.3.2.tar.gz"
    sha256 "0b66f4db3a9c39a6e22dd247c72cfaa57d68ea660e94bb2c84ec7db8712af190"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/7d/d9/2aa3b95ef02b60c5953031faba2e966155ef6c57aeac1a6d61d95acf9b4f/htmldate-1.9.2.tar.gz"
    sha256 "89553fb6e0942a18951a623e28ce3ce4a2e8543b3908e951eea356ec0346cbe4"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/b1/59/93ce612fce25c274efc88ec4d65963ce80fce96b9048e9fc1e430d893a9e/justext-3.0.1.tar.gz"
    sha256 "b6ed2fb6c5d21618e2e34b2295c4edfc0bcece3bd549ed5c8ef5a8d20f0b3451"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/81/f2/fe319e3c5cb505a361b95d1e0d0d793fe28d4dcc2fc39d3cae9324dc4233/lxml_html_clean-0.4.1.tar.gz"
    sha256 "40c838bbcf1fc72ba4ce811fbb3135913017b27820d7c16e8bc412ae1d8bc00b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end
