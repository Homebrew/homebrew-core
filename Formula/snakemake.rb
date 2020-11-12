class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/6f/c4/da52bfdd6168ea46a0fe2b7c983b6c34c377a8733ec177cc00b197a96a9f/snakemake-5.28.0.tar.gz"
  sha256 "2367ce91baf7f8fa7738d33aff9670ffdf5410bbac49aeb209f73b45a3425046"
  license "MIT"
  head "https://github.com/snakemake/snakemake.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "17d8ec4d0666fa220266bda87c5661b14187f5af7f3522ce80482e4aded3dbac" => :catalina
    sha256 "f3a0061aff5a5d7faac89271d592b66281ade2122ab1759acef43a16dbd31050" => :mojave
    sha256 "3b10b576bfcb786027cd090a1bddc54ff94ce5fe70364c6659131d23f90d0d22" => :high_sierra
  end

  depends_on "cbc"
  depends_on "python@3.9"

  resource "amply" do
    url "https://files.pythonhosted.org/packages/1c/52/f44d55940bd1c07818c3d45a04a3fe98bb1fb6f7ed3cf2c82b7e6c8467f3/amply-0.1.4.tar.gz"
    sha256 "cb12dcb49d16b168c02be128a1527ecde50211e4bd94af76ff4e67707f5a2d38"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e6/de/879cf857ae6f890dfa23c3d6239814c5471936b618c8fb0c8732ad5da885/certifi-2020.11.8.tar.gz"
    sha256 "f05def092c44fbf25834a51509ef6e631dc19765ab8a57b4e7ab85531f0a9cf4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/bb/79/3045743bb26ca2e44a1d317c37395462bfed82dbbd38e69a3280b63696ce/ConfigArgParse-1.2.3.tar.gz"
    sha256 "edd17be986d5c1ba2e307150b8e5f5107aba125f3574dddd02c85d5cdcfd37dc"
  end

  resource "datrie" do
    url "https://files.pythonhosted.org/packages/9d/fe/db74bd405d515f06657f11ad529878fd389576dca4812bea6f98d9b31574/datrie-0.8.2.tar.gz"
    sha256 "525b08f638d5cf6115df6ccd818e5a01298cd230b2dac91c8ff2e6499d18765d"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/d1/05/eaf2ac564344030d8b3ce870b116d7bb559020163e80d9aa4a3d75f3e820/gitdb-4.0.5.tar.gz"
    sha256 "c9e1f2d0db7ddb9a704c2a0217be31214e91a4fe1dea1efad19ae42ba0c285c9"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/85/3d/ee9aa9c77a3c0e9074461d2d8da86c3564ed96abd28fa099dc3e05338a72/GitPython-3.1.11.tar.gz"
    sha256 "befa4d101f91bad1b632df4308ec64555db684c360bd7d2130b4807d49ce86b8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/28/64/8bdde111be57a2a3d54376db29b5f25ab9c68ffd3d6554989db24d5c1b7a/jupyter_core-4.6.3.tar.gz"
    sha256 "394fd5dd787e7c8861741880bdf8a00ce39f95de5d18e579c74b882522219e7e"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/ad/6c/ab9715323ed5c0893f619788e5c0a452c42fce4a42c032245eae2c2fa31d/nbformat-5.0.8.tar.gz"
    sha256 "f545b22138865bfbcc6b1ffe89ed5a2b8e2dc5d4fe876f2ca60d8e6f702a30f8"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/33/e0/82d459af36bda999f82c7ea86c67610591cf5556168f48fd6509e5fa154d/psutil-5.7.3.tar.gz"
    sha256 "af73f7bcebdc538eda9cc81d19db1db7bf26f103f91081d780bbacfcb620dee2"
  end

  resource "PuLP" do
    url "https://files.pythonhosted.org/packages/25/f7/a8f9105d5a7c364949f19620d166bf96745ae221d6863b4d09291ac8e0c5/PuLP-2.3.1.tar.gz"
    sha256 "5bbe53f854fb3b689e4faacac5bdb5fa576cb270fc12c78edef827dd46a4fb50"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/4d/70/fd441df751ba8b620e03fd2d2d9ca902103119616f0f6cc42e6405035062/pyrsistent-0.17.3.tar.gz"
    sha256 "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "ratelimiter" do
    url "https://files.pythonhosted.org/packages/5b/e0/b36010bddcf91444ff51179c076e4a09c513674a56758d7cfea4f6520e29/ratelimiter-1.2.0.post0.tar.gz"
    sha256 "5c395dcabdbbde2e5178ef3f89b568a3066454a6ddc223b76473dac22f89b4f7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9f/14/4a6542a078773957aa83101336375c9597e6fe5889d20abda9c38f9f3ff2/requests-2.25.0.tar.gz"
    sha256 "7f1a0b932f4a60a1a65caa4263921bb7d9ee911957e0ae4a23a6dd08185ad5f8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/75/fb/2f594e5364f9c986b2c89eb662fc6067292cb3df2b88ae31c939b9138bb9/smmap-3.0.4.tar.gz"
    sha256 "9c98bbd1f9786d22f14b3d4126894d56befb835ec90cef151af566c7e19b5d24"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/e5/d8/9bc1598ddf74410beba243ffeaee8d0b3ca7e9ac5cefe77367da497433e1/toposort-1.5.tar.gz"
    sha256 "dba5ae845296e3bf37b042c640870ffebcdeb8cd4df45adaa01d8c5476c557dd"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/b8/24/e6dfe45ecfc4c2b0d6774565e631dc1b9e50de2c3536625d377963d56cae/traitlets-5.0.5.tar.gz"
    sha256 "178f4ce988f69189f7e523337a3e11d91c786ded9360174a3d9ca83e79bc5396"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Snakefile").write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakemake --cores 1 -s #{testpath}/Snakefile 2>&1")
    assert_predicate testpath/"test.out", :exist?
    assert_match "Building DAG of jobs...", test_output
  end
end
