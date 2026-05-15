class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/82/f8/909641e6a9fe3bf315df9032a2875eff5981b95c90df55f269506fadb6c9/yubikey_manager-5.9.1.tar.gz"
  sha256 "83bda2a4bbb6a93bc07e5de73a0f30e5a8b811c85a9116aaca6dd3eed8abb0eb"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf859a30150126d9c89b96b68ea34bf8732038c4e9994dcb839f61bf29bab31a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c37c83836987bad57e30fc21e557502612b67ef3609be0cf352fa5f53eb95bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a838a35fbba8b75608dd798a807334221bee689e4911a98f235ddc07a5a7766c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d08316c01d306417e9eda4399a4d05c86a07dd78562416c97bb9a6dee5c92e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9ed160c7ece658a86c23178af0fad0735aceac2e4b0297a960e8ec83f212b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "158d7fc5e56b1141ad6ca5b6e27b20e31097ee1875d79175430bd3840ded1728"
  end

  depends_on "cmake" => :build # for more-itertools
  depends_on "swig" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "pcsc-lite"

  pypi_packages exclude_packages: "cryptography",
                extra_packages:   %w[jeepney secretstorage]

  resource "click" do
    url "https://files.pythonhosted.org/packages/57/75/31212c6bf2503fdf920d87fee5d7a86a2e3bcf444984126f13d8e4016804/click-8.3.2.tar.gz"
    sha256 "14162b8b3b3550a7d479eafa77dfd3c38d9dc8951f6f69c78913a8f9a7540fd5"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/09/34/4837e2f5640baf61d8abd6125ccb6cc60b4b2933088528356ad6e781496f/fido2-2.2.0.tar.gz"
    sha256 "0d8122e690096ad82afde42ac9d6433a4eeffda64084f36341ea02546b181dd1"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/93/c9/65c68738a94b44b67b3c5e68a815890bbd225f2ae11ef1ace9b61fa9d5f3/pyscard-2.3.1.tar.gz"
    sha256 "a24356f57a0a950740b6e54f51f819edd5296ee8892a6625b0da04724e9e6c13"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-pskc" do
    url "https://files.pythonhosted.org/packages/bb/96/877a597fc0bd9a3ed33ada8b30a93f9705805dc43a330e048a8bb1078365/python_pskc-1.4.tar.gz"
    sha256 "4a36381446ca067be728b30e01b4d18dbd9d1ad553bf07c3710abcd87653eefe"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    without = ["pyscard"]
    without += %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    # Use brewed swig
    # https://github.com/Homebrew/homebrew-core/pull/176069#issuecomment-2200583084
    # https://github.com/LudovicRousseau/pyscard/issues/169#issuecomment-2200632337
    resource("pyscard").stage do
      inreplace "pyproject.toml", 'requires = ["setuptools","swig"]', 'requires = ["setuptools"]'
      venv.pip_install Pathname.pwd
    end

    man1.install "man/ykman.1"
    generate_completions_from_executable(bin/"ykman", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
