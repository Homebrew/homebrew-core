class Sysaidmin < Formula
  include Language::Python::Virtualenv

  desc "GPT-powered sysadmin"
  homepage "https://github.com/skorokithakis/sysaidmin"
  url "https://files.pythonhosted.org/packages/59/01/4f961856c3cfb32136782b119b3944466df81fb542dc6c214dc3386245f0/sysaidmin-0.2.2.tar.gz"
  sha256 "1bb2b343a0dffb9282e9a2ebddbb825e416b1cc0e9821ed25ded756c86362f47"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7798ca068c13be7451d365618c879580beea9d69de17a8f6863d638d7760abad"
    sha256 cellar: :any,                 arm64_sonoma:  "61977e8326ee3f7cd2cd93edd97ceb3b1f44a0028063ea137132efc5891c082d"
    sha256 cellar: :any,                 arm64_ventura: "063e6c813e6f8ddd82e88aad47a806b357d1d4b6ed826197ac9d72c738a8b486"
    sha256 cellar: :any,                 sonoma:        "086c36439a4211cd88bd7d4bf8c697896a1f8021027680024d9ed7209a52a42a"
    sha256 cellar: :any,                 ventura:       "b8e4cfd27566802009ea1075accabc9897cd87aedabc733e0927cf91bc02e217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929b71dfe7a662893ff1ff029b3c5db939318a886db2f7c7ba9c1b3ebc7d42e2"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/eb/27/6fa26db273f2454d25104b3327192fca83a08eec62f8d61c1078d4a4ed66/anyio-4.6.1.tar.gz"
    sha256 "936e6613a08e8f71a300cfffca1c1c0806335607247696ac45f9b32c63bfb9aa"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/b6/44/ed0fa6a17845fb033bd885c03e842f08c1b9406c86a2e60ac1ae1b9206a6/httpcore-1.0.6.tar.gz"
    sha256 "73f6dbd6eb8c21bbf7ef8efad555481853f5f6acdeaff1edb0694289269ee17f"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/26/ef/64458dfad180debd70d9dd1ca4f607e52bb6de748e5284d748556a0d5173/jiter-0.6.1.tar.gz"
    sha256 "e19cd21221fc139fb032e4112986656cb2739e9fe6d84c13956ab30ccc7d4449"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/95/64/9a5279138b5ea6c2f0e5443d5d93b4510cb87fa6fe7be0c92b837087124e/openai-1.51.2.tar.gz"
    sha256 "c6a51fac62a1ca9df85a522e462918f6bb6bc51a8897032217e453a0730123a6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/a9/b7/d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30/pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e2/aa/6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3/pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    # $ sysaidmin "The foo process is emailing me and I don't know why."
    output = shell_output("#{bin}/sysaidmin 'The foo process is emailing me and I dont know why.' 2>&1", 1)
    assert_match "Incorrect API key provided", output

    assert_match version.to_s, shell_output(bin/"sysaidmin --version")
  end
end
