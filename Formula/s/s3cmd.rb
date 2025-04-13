class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/b3/9c/ad4cd51328bd7a058bfda6739bc061c63ee3531ad2fbc6e672518a1eed01/s3cmd-2.4.0.tar.gz"
  sha256 "6b567521be1c151323f2059c8feec85ded96b6f184ff80535837fea33798b40b"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14b322ca3b3b43c0f0ef051dee2908cf1c16482d4e7ba74a1865860c8956edd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14b322ca3b3b43c0f0ef051dee2908cf1c16482d4e7ba74a1865860c8956edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b14b322ca3b3b43c0f0ef051dee2908cf1c16482d4e7ba74a1865860c8956edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "95771bafe9227af6ab7289809d0e989403d0a41f538db66afd963048fbc7a18a"
    sha256 cellar: :any_skip_relocation, ventura:       "95771bafe9227af6ab7289809d0e989403d0a41f538db66afd963048fbc7a18a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9423264039751971eb13ebd7df19bbe138a14280e71f633cc0a396285e1dcd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff809e6935a4f1e5973d1e6d60ee4f04d9aecc4151f3a734df55d4ea3609b90"
  end

  depends_on "libmagic" # for python-magic
  depends_on "python@3.13"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".s3cfg").write <<~INI
      [default]
      access_key = FAKE_KEY
      secret_key = FAKE_SECRET
    INI
    output = shell_output("#{bin}/s3cmd ls s3://brewtest 2>&1", 77)
    assert_match "ERROR: S3 error: 403 (InvalidAccessKeyId)", output

    assert_match "s3cmd version #{version}", shell_output("#{bin}/s3cmd --version")
  end
end
