class Sail < Formula
  include Language::Python::Virtualenv

  desc "CLI toolkit to provision and deploy WordPress applications to DigitalOcean"
  homepage "https://sailed.io"
  url "https://files.pythonhosted.org/packages/3a/6c/39b5e5e0ce557ddd98b6af0223b7a63afcc40b3646ee1a2511805dc45a08/sailed.io-0.10.6.tar.gz"
  sha256 "158ed9f03bcbcefa080647da90bc64d0acdec26514a3635a2843233eea90efa0"
  license "GPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cf0baab5fe8726ffe9b26ecc32c0d2884b61481b477dc7c8d02163f743f1794"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d88782970e3508d083d209dfc55c5f2e77ef2ff7d545defeda475a2f85332861"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a2109285aca2bf528e938080009b143b0fc987f797c12d819cf49ad3bda4351"
    sha256 cellar: :any_skip_relocation, ventura:        "98423e2ed9669bd69a18e939ffa08017d4f07e297b9eecff610532d4db000034"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb73ab60c7660588a0f0be3bd420984195ee90d138e2207df804a2ddccb763c"
    sha256 cellar: :any_skip_relocation, big_sur:        "418e1058704136a8a6764d2ec4868068f2d826e1be8273c86fb4e634a42a6d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cac09d131a087eb9044cbcd108961b92b076a1a10146e40f5729058aaa4aec26"
  end

  depends_on "fabric"
  depends_on "pyinvoke"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/89/e3/b36266381ae7a1310a653bb85f4f3658c462a69634fa9b2fef76252a50ed/Jinja2-3.1.1.tar.gz"
    sha256 "640bed4bb501cbd17194b3cace1dc2126f5b619cf068a726b98192a0fde74ae9"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/2b/3f/dd9bc9c1c9e57c687e8ebc4723e76c48980004244cf8db908a7b2543bd53/jsonpickle-3.0.1.tar.gz"
    sha256 "032538804795e73b94ead410800ac387fdb6de98f8882ac957fcd247e3a85200"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/c0/ef/61c7d422df129f340d25127d1f8744c6ae1eda2f3aed978fdc7abad03d02/tldextract-3.2.0.tar.gz"
    sha256 "3d4b6a2105600b7d0290ea237bf30b6b0dc763e50fcbe40e849a019bd6dbcbff"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    site_packages = Language::Python.site_packages(python3)
    %w[fabric pyinvoke].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end

    venv.pip_install_and_link buildpath
  end

  test do
    xy = Language::Python.major_minor_version "#{libexec}/bin/python"
    unittest = "#{libexec}/bin/python -m unittest discover " \
               "#{libexec}/lib/python#{xy}/site-packages/sail/tests 2>&1"

    assert_match(version.to_s, shell_output("#{bin}/sail --version"))
    assert_match("Could not parse .sail/config.json", shell_output("#{bin}/sail deploy 2>&1", 1))
    assert_match("OK", shell_output(unittest))
  end
end
