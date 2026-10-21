class Subliminal < Formula
  include Language::Python::Virtualenv

  desc "Library to search and download subtitles"
  homepage "https://subliminal.readthedocs.io"
  url "https://files.pythonhosted.org/packages/e7/3d/ff49ee5bffbac38dc4d4a154d11115e854859c0d65315594090a8275e1ed/subliminal-2.8.0.tar.gz"
  sha256 "0d784e621d0fa7d173f75798427b3572d4ab071a90bc0b9a8a88f1925670f691"
  license "MIT"
  head "https://github.com/Diaoul/subliminal.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "92987be181d593533e22371f0e9e75398d3a8e14f38990a17e813e5dc947be14"
    sha256 cellar: :any, arm64_tahoe:       "b86ad778fc48699326cc7eca8bd7b42e9f4708f0ea10b79009702a09634c2bc1"
    sha256 cellar: :any, arm64_sequoia:     "92cee8676ca6b88fa8863f6f4b46b8538c5b9dce04174dc5b9f0ff073049c70e"
    sha256 cellar: :any, arm64_linux:       "870601b7e98df7fbd39b6c39479c2cd76a6c8399ed4e1ba1591a4f40e589ddf4"
    sha256 cellar: :any, x86_64_linux:      "6a0b27de0d6042e357093b09c6c7449fdc1d5b4c18a0b7eb5c2686441966e567"
  end

  depends_on "rust" => :build # for rebulk > uv_build > maturin
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/b1/51/cd61c567092a6cec796144510a68aff158ebfc1df82950a45bae65f28413/chardet-7.6.0.tar.gz"
    sha256 "93d9df6089ded42ed1fe9f57e272c0b74bd0464d45c0c7d50f09f26f31105c3c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/ef/ff/d291d66595b30b83d1cb9e314b2c9be7cfc7327d4a0d40a15da2416ea97b/click_option_group-0.5.9.tar.gz"
    sha256 "f94ed2bc4cf69052e0f29592bd1e771a1789bd7bfc482dd0bc482134aff95823"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "enzyme" do
    url "https://files.pythonhosted.org/packages/6e/d8/a390f96ac0ccc33ca1c0e5c9cb9fc73f0623117e310594b6bc3be87005de/enzyme-0.5.2.tar.gz"
    sha256 "7cf779148d9e66eb2838603eace140c53c3cefc8b8fe5d4d5a03a5fb5d57b3c1"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/a7/59/7efd84be0e171260ba4252dab8415d60a5500c22148fa91c61f727a6c909/guessit-4.4.0.tar.gz"
    sha256 "cca2c19ecd872c75ee7ebcbdc11075f5ae884882ec0ad67f742c3d25f2d47beb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "knowit" do
    url "https://files.pythonhosted.org/packages/c5/fe/5a7691c55e27051a9b9d2657e8417b5bc927524db1507683111d54192542/knowit-0.7.1.tar.gz"
    sha256 "66e5601873c18776411eb18294a17ddfef9243e64bf9635df8cf6549090bbb80"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "pymediainfo" do
    url "https://files.pythonhosted.org/packages/4d/80/80a6fb21005b81e30f6193d45cba13857df09f5d483e0551fa6fbb3aaeed/pymediainfo-7.0.1.tar.gz"
    sha256 "0d5df59ecc615e24c56f303b8f651579c6accab7265715e5d429186d7ba21514"
  end

  resource "pysubs2" do
    url "https://files.pythonhosted.org/packages/f2/20/9071b8b0012d9102e90292c71fe3f1181c33e772e28cbabb4779c0087603/pysubs2-1.9.0.tar.gz"
    sha256 "4592405e5d961e23cd39c81e2875fb85c30346ae37d100f144cd7fd8ec560e42"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/09/d4/77c29644d1f9b1ef2881211c9c2a0f89d437f28c80edbc74c698f23055bd/rebulk-6.0.1.tar.gz"
    sha256 "d6df0c8c896e160087c6981f3770ed513ec973a9f4066b9e4b0614eb08ba0ce1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/5e/77/2dcfa996b01702ab8fd0763d84098f6a640d6162a328f1c04c2697579a1a/soupsieve-3.0.3.tar.gz"
    sha256 "7dcf6022eed0399eb9934a75e020148f7a2024c37b7dfcd3cf2c5505d69c364e"
  end

  resource "srt" do
    url "https://files.pythonhosted.org/packages/66/b7/4a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030/srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trakit" do
    url "https://files.pythonhosted.org/packages/47/35/e2273b5152ff6f77b9dd6449547c4d14bfb170fa00893f64fd785ec67116/trakit-0.4.0.tar.gz"
    sha256 "bdf04ca6840ce25f60bc31c4496832e8c14167725b9240badf0e2edf38bb7305"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"subliminal", shell_parameter_format: :click)
  end

  test do
    (testpath/".config").mkpath
    system bin/"subliminal", "download", "-l", "en",
               "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
    assert_path_exists testpath/"The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.en.srt"
  end
end
