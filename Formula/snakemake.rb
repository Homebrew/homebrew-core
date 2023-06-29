class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/ef/d7/8173e012d95dc7ea0fae8128e90240b65ac5e24a91a59ef812076a46ac68/snakemake-7.30.1.tar.gz"
  sha256 "0e907ae6ea18a7e7c8b9f08976ee1874da66f79cbd4ad1b25cc7e7b9a8670f80"
  license "MIT"
  head "https://github.com/snakemake/snakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "064b29466bac94d7dab8b64a84b20890f578708f191282620ecede680e66655f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e918207d01dafd6c15c03dbe2bb340c15a1491f48b63ca7a04357a1809ba764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74c89675eec2c0bc29f9e52ae8f6fa71f0223419759f82d5281091ca57102e8c"
    sha256 cellar: :any_skip_relocation, ventura:        "4a5adeb448ec580b78031c1b9f3dccdb844cd43e8d385033e367c0b55963c5b4"
    sha256 cellar: :any_skip_relocation, monterey:       "f8234c40b28ec8f0c7c16fb34feef573954ec31d3f54b64b22909863e4e34fb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "436bae8881a9c4e426f199b26380695b1325a5b72a20d46a925dc25d13d9af3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "477fe7d99462e4f57b0794c2295418998be7197d516810802ff2b44c01db5227"
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
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3c/fb/bf200c55a1e7014577c37fa9cbfa0148f629762bb3acff56299d8c58cbc3/ConfigArgParse-1.5.5.tar.gz"
    sha256 "363d80a6d35614bd446e2f2b1b216f3b33741d03ac6d0a92803306f40e555b58"
  end

  resource "connection-pool" do
    url "https://files.pythonhosted.org/packages/bd/df/c9b4e25dce00f6349fd28aadba7b6c3f7431cc8bd4308a158fbe57b6a22e/connection_pool-0.0.3.tar.gz"
    sha256 "bf429e7aef65921c69b4ed48f3d48d3eac1383b05d2df91884705842d974d0dc"
  end

  resource "datrie" do
    url "https://files.pythonhosted.org/packages/9d/fe/db74bd405d515f06657f11ad529878fd389576dca4812bea6f98d9b31574/datrie-0.8.2.tar.gz"
    sha256 "525b08f638d5cf6115df6ccd818e5a01298cd230b2dac91c8ff2e6499d18765d"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/0a/81/044f03129b6006fc594654bb26c22a9417346037261c767ac6e0773ca1dd/dpath-2.1.6.tar.gz"
    sha256 "f1e07c72e8605c6a9e80b64bc8f42714de08a789c7de417e49c3f87a19692e47"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/a4/e1/cda97fa4447e138f1f0ccfdaf678fa247415f7e9f4942d856fd63c7d863c/fastjsonschema-2.17.1.tar.gz"
    sha256 "f4eeb8a77cef54861dbf7424ac8ce71306f12cbb086c45131bcba2c6a4f726e3"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/9e/53/f27bd74ceaa672a1ce17b4b2bee93c0742ca00cb9f540ec4fa60cf7319b5/jupyter_core-5.3.1.tar.gz"
    sha256 "5ba5c7938a7f97a6b0481463f7ff0dbac7c15ba48cf46fa4035ca6e838aa1aba"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/73/b0/7dcb4288e9096fc544e4c511253c5720210748dd37c23f0486541d145a0a/nbformat-5.9.0.tar.gz"
    sha256 "e98ebb6120c3efbafdee2a40af2a140cadee90bb06dd69a2a63d9551fcc7f976"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "plac" do
    url "https://files.pythonhosted.org/packages/45/39/db67ba7731ab4461c1d365aac1df695712bb6b9629e56540789a36d5c3aa/plac-1.3.5.tar.gz"
    sha256 "38bdd864d0450fb748193aa817b9c458a8f5319fbf97b2261151cfc0a5812090"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cb/10/e5478cc0c3ee5563f91ab7b9da15d16e21f3737b6286ed3fd9a8fb1a99dd/platformdirs-3.8.0.tar.gz"
    sha256 "b0cabcb11063d21a0b261d557acb0a9d2126350e63b70cdf7db6347baea456dc"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "pulp" do
    url "https://files.pythonhosted.org/packages/59/41/44d617a67407ea5db026500025b8aa7cad0b2b52621c04991b248c3b383d/PuLP-2.7.0.tar.gz"
    sha256 "e73ee6b32d639c9b8cf4b4aded334ba158be5f8313544e056f796ace0a10ae63"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
    url "https://files.pythonhosted.org/packages/69/19/8e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678b/toposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/39/c3/205e88f02959712b62008502952707313640369144a7fded4cbc61f48321/traitlets-5.9.0.tar.gz"
    sha256 "f6cde21a9c68cf756af02035f72d5a723bf607e862e7be33ece505abf4a3bad9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
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
