class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/c3/47/c565a405fe1cc4e4ee9f79f1fb0773b14b7ed1c605c074aa4b189e01def0/snakemake-7.14.2.tar.gz"
  sha256 "d128b51803b54736dd6b804fb86fab8843d5698f96db30237c258487a61ede3a"
  license "MIT"
  head "https://github.com/snakemake/snakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48725a33b96435ad6c77ed6f7959f1d56eacc496aa32613195be2040dad3df4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfd0db9d4de5af57ea21cef734e99e7da03a81097c7ee22f73649f47a2c7eefb"
    sha256 cellar: :any_skip_relocation, monterey:       "bcc3df6ee05025d07500d6b16e6d1eb151cc042109790356b3e953f9c40b8c8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e7c43ad40086da8b578ff2d1542d6f1704eabb7742c573cfe34732edf6203da"
    sha256 cellar: :any_skip_relocation, catalina:       "3aee40815b46e51ab234e3dc9b14157081e8246a71ada319b4f465e60b010486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d231d8aa5b44c4624682399179c2c4b2e21ebd5de4eaec55a94ef2e9b3bcd606"
  end

  depends_on "cbc"
  depends_on "jsonschema"
  depends_on "libpython-tabulate"
  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
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

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/a0/cf/cf35f8b7f212be18634970a5b2d7a50adc715e649a0a8fedb06c909603d8/dpath-2.0.6.tar.gz"
    sha256 "5a1ddae52233fbc8ef81b15fb85073a81126bb43698d3f3a1b6aaf561a46cdc0"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/7a/62/6df03bacda3544b5872d0b30f79c599ab84fc598858c77a77e1587d61ba3/fastjsonschema-2.16.2.tar.gz"
    sha256 "01e366f25d9047816fe3d288cbfc3e10541daf0af2044763f3d0ade42476da18"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/e4/e0/13fc7f8b72f39d87c1c32918a99475911b7b2f28c1a9f2734a5ab5cc35ef/jupyter_core-4.11.1.tar.gz"
    sha256 "2e5f244d44894c4154d06aeae3419dd7f1b0ef4494dc5584929b398c61cfd314"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/44/08/6819f06aba37c6262911b0165e2680fa5e691d72b8f63634869cb4aad656/nbformat-5.6.1.tar.gz"
    sha256 "146b5b9969391387c2089256359f5da7c718b1d8a88ba814320273ea410e646e"
  end

  resource "plac" do
    url "https://files.pythonhosted.org/packages/45/39/db67ba7731ab4461c1d365aac1df695712bb6b9629e56540789a36d5c3aa/plac-1.3.5.tar.gz"
    sha256 "38bdd864d0450fb748193aa817b9c458a8f5319fbf97b2261151cfc0a5812090"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/8f/57/828ac1f70badc691a716e77bfae258ef5db76bb7830109bf4bcf882de020/psutil-5.9.2.tar.gz"
    sha256 "feb861a10b6c3bb00701063b37e4afc754f8217f0f09c42280586bd6ac712b5c"
  end

  resource "PuLP" do
    url "https://files.pythonhosted.org/packages/3a/74/0d6744ac87cbe9773be70917381d1834ac44015af7b6fa5cbc07b61abf03/PuLP-2.6.0.tar.gz"
    sha256 "4b4f7e1e954453e1b233720be23aea2f10ff068a835ac10c090a93d8e2eb2e8d"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "ratelimiter" do
    url "https://files.pythonhosted.org/packages/5b/e0/b36010bddcf91444ff51179c076e4a09c513674a56758d7cfea4f6520e29/ratelimiter-1.2.0.post0.tar.gz"
    sha256 "5c395dcabdbbde2e5178ef3f89b568a3066454a6ddc223b76473dac22f89b4f7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "retry" do
    url "https://files.pythonhosted.org/packages/9d/72/75d0b85443fbc8d9f38d08d2b1b67cc184ce35280e4a3813cda2f445f3a4/retry-0.9.2.tar.gz"
    sha256 "f8bfa8b99b69c4506d6f5bd3b0aabf77f98cdb17f3c9fc3f5ca820033336fba4"
  end

  resource "smart-open" do
    url "https://files.pythonhosted.org/packages/62/d8/c25a41a4a652984706b1e3529ebb1150c07dd1d7c69892f8a6d5ac1b792c/smart_open-6.2.0.tar.gz"
    sha256 "1b4df5c8365218f3852c507451920ccad606c80b0acb4e67508e50ba9b5d2632"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stopit" do
    url "https://files.pythonhosted.org/packages/35/58/e8bb0b0fb05baf07bbac1450c447d753da65f9701f551dca79823ce15d50/stopit-1.1.2.tar.gz"
    sha256 "f7f39c583fd92027bd9d06127b259aee7a5b7945c1f1fa56263811e1e766996d"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/b2/be/67bec9a73041616dd359f06e997d56c9c99d252460a3f035411d97c96c48/toposort-1.7.tar.gz"
    sha256 "ddc2182c42912a440511bd7ff5d3e6a1cabc3accbc674a3258c8c41cbfbb2125"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/a2/4d/1f59a77fba6e8e9feea7a168652030564089d66c06492ba5670e73b0e078/traitlets-5.4.0.tar.gz"
    sha256 "3f2c4e435e271592fe4390f1746ea56836e3a080f84e7833f0f801d9613fec39"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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

    # we depend on jsonschema, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    jsonschema = Formula["jsonschema"].opt_libexec
    (libexec/site_packages/"homebrew-jsonschema.pth").write jsonschema/site_packages
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
