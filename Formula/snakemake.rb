class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/90/37/3ee66d42ecf4c8398299416b9beb98987d15e2c2200c555bf0d9f6a6dbba/snakemake-6.10.0.tar.gz"
  sha256 "199a86c8d1fcfdb88c4271a1507b0ab371a15bc407f2dad9b0ab8c43438adff8"
  license "MIT"
  head "https://github.com/snakemake/snakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9366f289a669ce8a03635e6d6b91a5f5a6bfc0b9b335d8385dba90f2e0c4d0c0"
    sha256 cellar: :any_skip_relocation, monterey:      "8b3d303d95a8557afb914b0c7591401edae9782cbf720f54621ebace97dc66c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "383e17698ec3918df8b9cca8fbee211fb0f9d390ec612f4ec610270cf90834cb"
    sha256 cellar: :any_skip_relocation, catalina:      "a658b966b8eae0776adbb8b970ec151ed48a5f2c83345ce9074b3d46ce162463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8e466e84be10432ab26fb85528af7fc6a1d91543c6af1a6ef9e3c288243040"
  end

  depends_on "cbc"
  depends_on "python@3.10"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
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

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/8f/eb/6faad9294c8a8d59b7599a8a7c669c0e4c317fa5012bc36f1c8b379972a5/filelock-3.3.1.tar.gz"
    sha256 "34a9f35f95c441e7b38209775d6e0337f9a3759f3565f6c5798f19618527c76f"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/34/fe/9265459642ab6e29afe734479f94385870e8702e7f892270ed6e52dd15bf/gitdb-4.0.7.tar.gz"
    sha256 "96bf5c08b157a666fec41129e6d327235284cca4c81e92109260f353ba138005"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/34/cc/aaa7a0d066ac9e94fbffa5fcf0738f5742dd7095bdde950bd582fca01f5a/GitPython-3.1.24.tar.gz"
    sha256 "df83fdf5e684fef7c6ee2c02fc68a5ceb7e7e759d08b694088d0cacb4eba59e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/94/b9/8be410108f775bbb97d74b9d95fbcaa8ca55de9f43fe73c5a3bd82a3a867/jsonschema-4.1.2.tar.gz"
    sha256 "5c1a282ee6b74235057421fd0f766ac5f2972f77440927f6471c9e8493632fac"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/bb/dc/bb0e8b5093582699271df99cad202390e5cfcdb6bc5e772ca2fa8f61ade6/jupyter_core-4.8.1.tar.gz"
    sha256 "ef210dcb4fca04de07f2ead4adf408776aca94d17151d6f750ad6ded0b91ea16"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/e5/bd/847367dcc514b198936a3de8bfaeda1935e67ce369bf0b3e7f3ed4616ae8/nbformat-5.1.3.tar.gz"
    sha256 "b516788ad70771c6250977c1374fcca6edebe6126fd2adb5a69aa5c2356fd1c8"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "PuLP" do
    url "https://files.pythonhosted.org/packages/14/7b/8b6d9ab49067ef2f19d383a31d3d373fba7faf106e759743fb58699114f1/PuLP-2.5.1.tar.gz"
    sha256 "27c2a87a98ea0e9a08c7c46e6df47d6d4e753ad9991fea2901892425d89c99a6"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "ratelimiter" do
    url "https://files.pythonhosted.org/packages/5b/e0/b36010bddcf91444ff51179c076e4a09c513674a56758d7cfea4f6520e29/ratelimiter-1.2.0.post0.tar.gz"
    sha256 "5c395dcabdbbde2e5178ef3f89b568a3066454a6ddc223b76473dac22f89b4f7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "smart-open" do
    url "https://files.pythonhosted.org/packages/53/9e/7a25cefbe4b51ea9bf883999c359dd761d32dcd2f764b70805278bb20bde/smart_open-5.2.1.tar.gz"
    sha256 "75abf758717a92a8f53aa96953f0c245c8cedf8e1e4184903db3659b419d4c17"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/dd/d4/2b4f196171674109f0fbb3951b8beab06cd0453c1b247ec0c4556d06648d/smmap-4.0.0.tar.gz"
    sha256 "7e65386bd122d45405ddf795637b7f7d2b532e7e401d46bbe3fb49b9986d5182"
  end

  resource "stopit" do
    url "https://files.pythonhosted.org/packages/35/58/e8bb0b0fb05baf07bbac1450c447d753da65f9701f551dca79823ce15d50/stopit-1.1.2.tar.gz"
    sha256 "f7f39c583fd92027bd9d06127b259aee7a5b7945c1f1fa56263811e1e766996d"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/b2/be/67bec9a73041616dd359f06e997d56c9c99d252460a3f035411d97c96c48/toposort-1.7.tar.gz"
    sha256 "ddc2182c42912a440511bd7ff5d3e6a1cabc3accbc674a3258c8c41cbfbb2125"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/d5/bc/37d490908e7ac949614d62767db3c86f37bc5adb6129d378c35859a75b87/traitlets-5.1.0.tar.gz"
    sha256 "bd382d7ea181fbbcce157c133db9a829ce06edffe097bcf3ab945b435452b46d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/57/f0/b9c4beb5be22485ff0f09427dcc4e483dbf3a34fd5afb4f93cd6c68b2fac/wrapt-1.13.2.tar.gz"
    sha256 "dca56cc5963a5fd7c2aa8607017753f534ee514e09103a6c55d2db70b50e7447"
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
