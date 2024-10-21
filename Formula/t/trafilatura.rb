class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/d0/cd/77e4403b61d5da59063bb65ee894cf951c6f1137658499947adc040102f5/trafilatura-1.12.2.tar.gz"
  sha256 "4c9cb1434f7e13ef0b16cb44ee1d44e84523ec7268940b9559c374e7effc9a96"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d2b05278b7dac67cb6511131caaed8d01c7e67bd9de37b43b94110b32f9cfd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38aba65a43e4a8fada4a651189743025f3e550c6bb014cd0c965df5910334de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1acaa03f8d69f8163d2e0806b4df842df4db88b00ec2c9a4c3a88f8643ffb841"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e15ff288507c4168e36dbe358db5100946edb8f8b2f284db23edbbd9453c8f"
    sha256 cellar: :any_skip_relocation, ventura:       "e7de935a43c32887142f8aff2bc22ce95e4628ff84d48534f672021fe7ce2b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59748caaa42f04dbe73e4c138a9c33cf0d5753ed0f06b7c909cf6a0314c7a7a5"
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
    url "https://files.pythonhosted.org/packages/9f/d4/50ac3848147e1c74d8f207064093dc2a62b8f51e0f615f7ba5cf5fd732f7/courlan-1.3.1.tar.gz"
    sha256 "10858ab686470a3b1d8748d7b88199607c94e74eba3c8ade759ba4a9576d366e"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/2e/a0/7abcfa08fd1eb3f8e5cd22f3fdea86d5c4e066360ff7966ce53c7d75f0e9/htmldate-1.9.1.tar.gz"
    sha256 "83eaad12c23b38aecb2b9fc2ceb131af815943ce3e1a0506a862eb256c16b606"
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
    url "https://files.pythonhosted.org/packages/eb/c9/efd2064658c33d248a9522825dfb38c82619579754c0320103e632829b16/lxml_html_clean-0.3.1.tar.gz"
    sha256 "d9f7d8ae36092f4ed5079cfbf95ff06d3c6fd04f4a861422ce251ece72d3c4b5"
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
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
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
