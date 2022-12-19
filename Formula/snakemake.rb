class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/92/11/db720239549ce18bcef241a4dd3868ad56e8c475a8b457fc3edbb5dc4f20/snakemake-7.19.1.tar.gz"
  sha256 "390ad5e2d5106e84700b7219c0eddf41d61be2205787d77a815fa91e4d624f33"
  license "MIT"
  revision 1
  head "https://github.com/snakemake/snakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "491e1e5a1df031bac9b6cc32a21cf4c51afbac7f84bc8a97c5d34749059f6907"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04c67a4d4147d620af3918435df5851e30c62298ddc6fe4e36b4372b24d58e92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5a0d99315eae9681a6173e8d36c25cdd59c444555ff3b57cb23343fea87823d"
    sha256 cellar: :any_skip_relocation, ventura:        "7c0907e59530ac8b78b66e7d3cea52348563825b1fc033a1a818c9a0ce8a1d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "ada4d2251e9db2b4792afc03f42297276ae8aaff60fe24400607c52538b7f90e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6f4353fd14097c707d926f71551d6e41fae6be8419dc5ff85aaceecb5846395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2344643066de5d6b8bb19283383b7ab7226dec2737cde5f3540f18ba250c3373"
  end

  depends_on "cbc"
  depends_on "docutils"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "connection_pool" do
    url "https://files.pythonhosted.org/packages/bd/df/c9b4e25dce00f6349fd28aadba7b6c3f7431cc8bd4308a158fbe57b6a22e/connection_pool-0.0.3.tar.gz"
    sha256 "bf429e7aef65921c69b4ed48f3d48d3eac1383b05d2df91884705842d974d0dc"
  end

  resource "datrie" do
    url "https://files.pythonhosted.org/packages/9d/fe/db74bd405d515f06657f11ad529878fd389576dca4812bea6f98d9b31574/datrie-0.8.2.tar.gz"
    sha256 "525b08f638d5cf6115df6ccd818e5a01298cd230b2dac91c8ff2e6499d18765d"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/1f/2c/a4213cdbbc43b8fdf34b6e2afb415fd5d46e171d32a4bb92e7924548aa9f/dpath-2.1.3.tar.gz"
    sha256 "d1a7a0e6427d0a4156c792c82caf1f0109603f68ace792e36ca4596fd2cb8d9d"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/7a/62/6df03bacda3544b5872d0b30f79c599ab84fc598858c77a77e1587d61ba3/fastjsonschema-2.16.2.tar.gz"
    sha256 "01e366f25d9047816fe3d288cbfc3e10541daf0af2044763f3d0ade42476da18"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/22/ab/3dd8b8a24399cee9c903d5f7600d20e8703d48904020f46f7fa5ac5474e9/GitPython-3.1.29.tar.gz"
    sha256 "cc36bfc4a3f913e66805a28e84703e419d9c264c1077e537b54f0e1af85dbefd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/99/db/4de1aaa121fcfa9db093554d6539a31c6b382480daac3172c6206a19367f/jupyter_core-5.1.0.tar.gz"
    sha256 "a5ae7c09c55c0b26f692ec69323ba2b62e8d7295354d20f6cd57b749de4a05bf"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/9c/54/5b39dfc6585e1dfc8c119252754c19dd85ee974606b73e3fa8a2242413d2/nbformat-5.7.0.tar.gz"
    sha256 "1d4760c15c1a04269ef5caf375be8b98dd2f696e5eb9e603ec2bf091f9b0d3f3"
  end

  resource "plac" do
    url "https://files.pythonhosted.org/packages/45/39/db67ba7731ab4461c1d365aac1df695712bb6b9629e56540789a36d5c3aa/plac-1.3.5.tar.gz"
    sha256 "38bdd864d0450fb748193aa817b9c458a8f5319fbf97b2261151cfc0a5812090"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ec/4c/9af851448e55c57b30a13a72580306e628c3b431d97fdae9e0b8d4fa3685/platformdirs-2.6.0.tar.gz"
    sha256 "b46ffafa316e6b83b47489d240ce17173f123a9b9c83282141c3daf26ad9ac2e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "PuLP" do
    url "https://files.pythonhosted.org/packages/59/41/44d617a67407ea5db026500025b8aa7cad0b2b52621c04991b248c3b383d/PuLP-2.7.0.tar.gz"
    sha256 "e73ee6b32d639c9b8cf4b4aded334ba158be5f8313544e056f796ace0a10ae63"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "reretry" do
    url "https://files.pythonhosted.org/packages/40/1d/25d562a62b7471616bccd7c15a7533062eb383927e68667bf331db990415/reretry-0.11.8.tar.gz"
    sha256 "f2791fcebe512ea2f1d153a2874778523a8064860b591cd90afc21a8bed432e3"
  end

  resource "smart-open" do
    url "https://files.pythonhosted.org/packages/b0/2b/ebc6d835bb354eb6d7f5f560be53dc746dab84d0958c363a082bfdf1e862/smart_open-6.3.0.tar.gz"
    sha256 "d5238825fe9a9340645fac3d75b287c08fbb99fb2b422477de781c9f5f09e019"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stopit" do
    url "https://files.pythonhosted.org/packages/35/58/e8bb0b0fb05baf07bbac1450c447d753da65f9701f551dca79823ce15d50/stopit-1.1.2.tar.gz"
    sha256 "f7f39c583fd92027bd9d06127b259aee7a5b7945c1f1fa56263811e1e766996d"
  end

  resource "throttler" do
    url "https://files.pythonhosted.org/packages/b4/22/638451122136d5280bc477c8075ea448b9ebdfbd319f0f120edaecea2038/throttler-1.2.2.tar.gz"
    sha256 "d54db406d98e1b54d18a9ba2b31ab9f093ac64a0a59d730c1cf7bb1cdfc94a58"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/b2/be/67bec9a73041616dd359f06e997d56c9c99d252460a3f035411d97c96c48/toposort-1.7.tar.gz"
    sha256 "ddc2182c42912a440511bd7ff5d3e6a1cabc3accbc674a3258c8c41cbfbb2125"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/0b/db/9adbbb2bef9a43ecfa4f1cbcec1d662adade10262328a4b7ef65effc6341/traitlets-5.7.1.tar.gz"
    sha256 "fde8f62c05204ead43c2c1b9389cfc85befa7f54acb5da28529d671175bb4108"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "yte" do
    url "https://files.pythonhosted.org/packages/bd/ec/85b6f67edccf6789bd5feeabe8906f5626e9328c9b340008ac0378668c59/yte-1.5.1.tar.gz"
    sha256 "6d0b315b78af83276d78f5f67c107c84238f772a76d74f4fc77905b46f3731f5"
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
