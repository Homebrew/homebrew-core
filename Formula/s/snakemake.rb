class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/a3/64/f800a50e590d86f1355d0de8575246a3ae8466f7b5179a6244bf13266a49/snakemake-9.11.9.tar.gz"
  sha256 "dfebcc7fb1bbbcdf1a9aa6507c1c7cbeb77e906ac4214c9d47e1db12d53a5abd"
  license "MIT"
  head "https://github.com/snakemake/snakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0934aa01b784d7b96f26a428ee54d9be014ff3e9401a36f334c473b8c0bb516d"
    sha256 cellar: :any,                 arm64_sequoia: "2535e293e9b8b419cc0e1f09c861b89d004a17cbaffb9e1f7e5fd163a1c28b32"
    sha256 cellar: :any,                 arm64_sonoma:  "0cf153584a1ae3057993d7f2eb701ec4d74557e3de908e286daa44ac3eb8238c"
    sha256 cellar: :any,                 sonoma:        "8a28618c892e48b36ef89d5b1141c29dac3b32eb70c0325747e47d4af54b047c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14eae73aebe885fb5a03f0460f831f8f55810bacb7fef2e7b57477c29e293845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26325e64ba73fe357b06638699b3a4db7b3365e5ab94c0c776cbaff0612e51db"
  end

  depends_on "rust" => :build
  depends_on "cbc"
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argparse-dataclass" do
    url "https://files.pythonhosted.org/packages/1a/ff/a2e4e328075ddef2ac3c9431eb12247e4ba707a70324894f1e6b4f43c286/argparse_dataclass-2.0.0.tar.gz"
    sha256 "09ab641c914a2f12882337b9c3e5086196dbf2ee6bf0ef67895c74002cc9297f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "conda-inject" do
    url "https://files.pythonhosted.org/packages/b1/a8/8dc86113c65c949cc72d651461d6e4c544b3302a85ed14a5298829e6a419/conda_inject-1.3.2.tar.gz"
    sha256 "0b8cde8c47998c118d8ff285a04977a3abcf734caf579c520fca469df1cd0aac"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "connection-pool" do
    url "https://files.pythonhosted.org/packages/bd/df/c9b4e25dce00f6349fd28aadba7b6c3f7431cc8bd4308a158fbe57b6a22e/connection_pool-0.0.3.tar.gz"
    sha256 "bf429e7aef65921c69b4ed48f3d48d3eac1383b05d2df91884705842d974d0dc"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4a/c0/89fe6215b443b919cb98a5002e107cb5026854ed1ccb6b5833e0768419d1/docutils-0.22.2.tar.gz"
    sha256 "9fdb771707c8784c8f2728b67cb2c691305933d68137ef95a75db5f4dfbc213d"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/b5/ce/e1fd64d36e4a5717bd5e6b2ad188f5eaa2e902fde871ea73a79875793fc9/dpath-2.2.0.tar.gz"
    sha256 "34f7e630dc55ea3f219e555726f5da4b4b25f2200319c8e6902c394258dd6a3e"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/20/b5/23b216d9d985a956623b6bd12d4086b60f0059b27799f23016af04a74ea1/fastjsonschema-2.21.2.tar.gz"
    sha256 "b1eb43748041c880796cd077f1a07c3d94e93ae84bba5ed36800a33554ae05de"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/9a/c8/dd58967d119baab745caec2f9d853297cec1989ec1d63f677d3880632b88/gitpython-3.1.45.tar.gz"
    sha256 "85b0ee964ceddf211c41b9f27a49086010a190fd8132a24e21f362a4b36a791c"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "immutables" do
    url "https://files.pythonhosted.org/packages/69/41/0ccaa6ef9943c0609ec5aa663a3b3e681c1712c1007147b84590cec706a0/immutables-0.21.tar.gz"
    sha256 "b55ffaf0449790242feb4c56ab799ea7af92801a0a43f9e2f4f8af2ab24dfc4a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/99/1b/72906d554acfeb588332eaaa6f61577705e9ec752ddb486f302dafa292d9/jupyter_core-5.8.1.tar.gz"
    sha256 "0a5f9706f70e64786b75acba995988915ebd4601c8a52e534a40b51c95f59941"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/6d/fd/91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3/nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "pulp" do
    url "https://files.pythonhosted.org/packages/16/1c/d880b739b841a8aa81143091c9bdda5e72e226a660aa13178cb312d4b27f/pulp-3.3.0.tar.gz"
    sha256 "7eb99b9ce7beeb8bbb7ea9d1c919f02f003ab7867e0d1e322f2f2c26dd31c8ba"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "reretry" do
    url "https://files.pythonhosted.org/packages/40/1d/25d562a62b7471616bccd7c15a7533062eb383927e68667bf331db990415/reretry-0.11.8.tar.gz"
    sha256 "f2791fcebe512ea2f1d153a2874778523a8064860b591cd90afc21a8bed432e3"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "smart-open" do
    url "https://files.pythonhosted.org/packages/16/be/bf2d60280a9d7fac98ece2150a22538fa4332cda67d04d9618c8406f791e/smart_open-7.3.1.tar.gz"
    sha256 "b33fee8dffd206f189d5e704106a8723afb4210d2ff47e0e1f7fbe436187a990"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "snakemake-interface-common" do
    url "https://files.pythonhosted.org/packages/fd/be/cbd3f30c24eecb0e7d48f7025c770b7dc664124a01c8d9df6da73eb4fbd1/snakemake_interface_common-1.22.0.tar.gz"
    sha256 "ef1fa710a15629be4cc352b938596ab5235ecf0b615c5845f086d6c5da10cb88"
  end

  resource "snakemake-interface-executor-plugins" do
    url "https://files.pythonhosted.org/packages/18/51/e62e14090393d6688e7d4026a574f0a9de14ffb678bc4c6993306fc3e62a/snakemake_interface_executor_plugins-9.3.9.tar.gz"
    sha256 "988ab388d48522fac84107867ae3f3398312b93b55df6ed7b99afc225468ca26"
  end

  resource "snakemake-interface-logger-plugins" do
    url "https://files.pythonhosted.org/packages/c0/92/2fe4fa879a5d4408cad6db5330cd4ebd352e47529cb0fdfdf8ebf73f2920/snakemake_interface_logger_plugins-2.0.0.tar.gz"
    sha256 "0e8ff2af4c55ca140d6ea1c1540e733a4b3944abae48fe0eaf6a707e5797cd17"
  end

  resource "snakemake-interface-report-plugins" do
    url "https://files.pythonhosted.org/packages/f1/0f/b0986bacc1087d549e2ce5f5987de73980dc7041b7c518286f5035160d89/snakemake_interface_report_plugins-1.2.0.tar.gz"
    sha256 "36cff4d50e7763ae0def0a7cf36d85e6c575d7bad1a3ade26b66c9b2b8831c02"
  end

  resource "snakemake-interface-scheduler-plugins" do
    url "https://files.pythonhosted.org/packages/ae/bf/b431786d74071726c6aed5f3536a03a4834c4a0286f5381e7be44269671a/snakemake_interface_scheduler_plugins-2.0.1.tar.gz"
    sha256 "c22deccc6df4c702e67d012650571fa858e8577b759d8cb4729d16b087852b43"
  end

  resource "snakemake-interface-storage-plugins" do
    url "https://files.pythonhosted.org/packages/dd/b3/cd5256e56cfe6fc51319a7d9df1a3a2a7584499fadd3c3fc5619ff39f74f/snakemake_interface_storage_plugins-4.2.3.tar.gz"
    sha256 "95be93d1aa1c56c189d9ff661930a6475e847a79a74013822c9570c0ef691755"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "throttler" do
    url "https://files.pythonhosted.org/packages/b4/22/638451122136d5280bc477c8075ea448b9ebdfbd319f0f120edaecea2038/throttler-1.2.2.tar.gz"
    sha256 "d54db406d98e1b54d18a9ba2b31ab9f093ac64a0a59d730c1cf7bb1cdfc94a58"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "yte" do
    url "https://files.pythonhosted.org/packages/d2/ac/eb7ef47a0d307737812f9d8734d288a429849d430049049370814ab814d9/yte-1.9.0.tar.gz"
    sha256 "d259548aa46c5d5ff318f3ecb1732918d1ac3c6708798767ce3823192ce1ba21"
  end

  def install
    venv = virtualenv_install_with_resources
    rm_r(venv.site_packages/"pulp/solverdir/cbc")
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
    assert_path_exists testpath/"test.out"
    assert_match "Building DAG of jobs...", test_output
  end
end
