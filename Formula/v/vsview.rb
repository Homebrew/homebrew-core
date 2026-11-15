class Vsview < Formula
  include Language::Python::Virtualenv

  desc "Next-generation VapourSynth previewer"
  homepage "https://jaded-encoding-thaumaturgy.github.io/vs-view/"
  url "https://files.pythonhosted.org/packages/20/16/7c51c29133cba6d01f9aae9708b1e9055ad8c94d32747620a4300828a96a/vsview-0.14.0.tar.gz"
  sha256 "c1f5c8a5d6d71e77460eda52c043081cce793f4911bf1dac613b82e56c1603e6"
  license all_of: [
    "EUPL-1.2",
    all_of: ["MIT", "Apache-2.0", "ISC", "OFL-1.1"], # src/vsview/assets/
  ]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a35876ef97ed6e2dccd23c06d1febfc31829818f3b8a26c0361eb856f93a34e0"
    sha256 cellar: :any, arm64_tahoe:       "e9239ae4d969e515c90cee4cd17718f650d63263a5f9412a3e3b672a66b8cf94"
    sha256 cellar: :any, arm64_sequoia:     "da7a92c029e602d1f717c9806b52a247966c8dcfc333580138e12e1ae9474f59"
    sha256 cellar: :any, arm64_linux:       "efcaa55ae9bbe125ce0c08fc3c913f178382b4d13fe64380c33f82d7e03d7916"
    sha256 cellar: :any, x86_64_linux:      "8c7fe80bd2cedc7ffe327ba27f60001f9a5724c9520d24453378082c31e0fc8b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "numpy"
  depends_on "pydantic" => :no_linkage
  depends_on "pyside"
  depends_on "python@3.15"
  depends_on "vapoursynth"
  depends_on "vapoursynth-bestsource" => :no_linkage
  depends_on "vapoursynth-vszip" => :no_linkage
  depends_on "zstd"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "cryptography"
  end

  pypi_packages package_name:     "vsview[recommended]",
                exclude_packages: %w[cryptography numpy pyside6 pydantic vapoursynth
                                     vapoursynth-bestsource vapoursynth-akarin vapoursynth-vszip],
                extra_packages:   %w[jeepney secretstorage] # Linux-only

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/79/39/307912fa6871e0e051895e17fc307f285826d52b88b85ea76d60479801f8/cyclopts-5.3.1.tar.gz"
    sha256 "a2e9bdddf3d724a5fb06cefb4a220ece34511e95e79da88ec56c25d6b9a7ee00"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
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
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jetpytools" do
    url "https://files.pythonhosted.org/packages/87/37/6c941547913727f6479464d557d35a0b38574d2d1047bc09285e076bcdfc/jetpytools-3.2.0.tar.gz"
    sha256 "d40b52b97e0e891bd827b1d8452f6da1da78f90b1ea814bc21c2117c864a6a79"
  end

  resource "jh2" do
    url "https://files.pythonhosted.org/packages/57/fa/a3ba1417800b142d6777c48657f6b01fc46bd1a4777aba979463e36d78c5/jh2-5.0.15.tar.gz"
    sha256 "53fb377caca50441fd1892f60745c44d3ba8c43844c3792e73c34bf9f841adaf"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
  end

  resource "niquests" do
    url "https://files.pythonhosted.org/packages/1c/2a/e368ec88a02c6bfc56c031ba6da9dd8099ad998fb818c28b687bee74c91a/niquests-3.21.2.tar.gz"
    sha256 "586d6b9475c9018a42f19f1e4688077b8158101cbf40673c63d2c1a096cc7665"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "qh3" do
    url "https://files.pythonhosted.org/packages/df/c3/777d963d852a19c1777eb74ab543d00d8b95592a849174d9a4f3b1c3f51a/qh3-2.1.0.tar.gz"
    sha256 "622e3c63f2417039785f61d6af2cb26d0f0e5935ac2b84ef85a2bf76862fe6f3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/cf/0e/faf7c7e36630561e3e9611730c47510cd972dd5fde8f95941ff78f76accd/rich_rst-2.2.0.tar.gz"
    sha256 "b1e6a67f8f694a6f36035624bf73e2b1a0a4be13edaf3ba5e654d9758b61073a"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "urllib3-future" do
    url "https://files.pythonhosted.org/packages/71/f0/3d87b7ecd92df7accecd0a4ac4d816cb151fabf6fdee359fe5d66f9b5f7d/urllib3_future-2.25.903.tar.gz"
    sha256 "ef0011def1c6724f418d7970200ab8ccaf7d034ece152717b368afe512fb6d53"
  end

  resource "vapoursynth-fftspectrum-rs" do
    url "https://files.pythonhosted.org/packages/13/56/9771adfbc1195017e887142cf03253316efac3d21d2f7f10900bdcf628df/vapoursynth_fftspectrum_rs-1.0.13.tar.gz"
    sha256 "bd2347222d833d82ba8f3b4e4cf45aea6276b7c48e5c3eb510198520bf15ebe6"
  end

  resource "vsjetengine" do
    url "https://files.pythonhosted.org/packages/08/f4/d6652409bd7762cb949f0c83b506c5cf2dceb9ff0824f8c5ccca5c437bb1/vsjetengine-2.0.0.tar.gz"
    sha256 "3441273712c893b537643f3021be32de6c0111f6c6637640df3d6a7a43d10733"
  end

  resource "vsjetpack" do
    url "https://files.pythonhosted.org/packages/a7/9c/7c44757910e8aa05b2f466b86e3d3b15bbf056a34741c094d4efeb44e0b8/vsjetpack-2.2.6.tar.gz"
    sha256 "54b90e82e6c9864d7becbbd4fffc29fc2f6e1e0216b475734026521c88f732c3"
  end

  resource "vspackrgb" do
    url "https://files.pythonhosted.org/packages/8c/31/b86c8da20ec38f49ef1ff57cb44785526e80fb2fd616d0ef3561b95e2fac/vspackrgb-2.0.0.tar.gz"
    sha256 "2325f436c00f943d182c233d73a3a529e050a3b03ff5144d56ac1f22e29f31d1"
  end

  resource "vsview-comp" do
    url "https://files.pythonhosted.org/packages/88/3a/6b8f5317e4ca4589cdde50c297e83e306f0fd26c4151d16bb37af7279338/vsview_comp-0.16.0.tar.gz"
    sha256 "72cd047eb22133a72d4e24145c130eac81e493555c9c1fec522cbb947e5e3c54"
  end

  resource "vsview-fftspectrum" do
    url "https://files.pythonhosted.org/packages/84/3b/c8f5b6c37b5f6d2d5ea319d7921f63f909d2d4269f1a113be806e2aaba49/vsview_fftspectrum-0.3.0.tar.gz"
    sha256 "87b5b0934f04b065542a93c0f07b2a9cc3898e28b7964e449ec894e4111d2860"
  end

  resource "vsview-frameprops-extended" do
    url "https://files.pythonhosted.org/packages/3f/b6/bf879e1070da2dc63658a604d2748086e2ca506d31905986fc5171d4a7b8/vsview_frameprops_extended-0.3.0.tar.gz"
    sha256 "7c5b6f18cfbaf907e4129a6cf56c95c4032f695e9d526d2bee1eec6f26b5a68a"
  end

  resource "vsview-split-planes" do
    url "https://files.pythonhosted.org/packages/06/62/6b975885f25d0c803f4e64341446a79ff416f69be6371767c45a97d16583/vsview_split_planes-0.3.0.tar.gz"
    sha256 "88e27a0ff190e6543998d67c319c259c1675466ff1d289012bc3abd3cb3b5f1a"
  end

  resource "wassima" do
    url "https://files.pythonhosted.org/packages/5c/8e/9167e3e39e921833d35119849422cfbbba68c90ad0723c2a9c7965303195/wassima-2.1.5.tar.gz"
    sha256 "b02c1985e527c9539396cc85b909857d810dafaaa318a30266e585a0e7135f54"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"
    # Stop urllib3-future shipping a `.pth` that overrides urllib3 and breaks nested builds
    ENV["URLLIB3_NO_OVERRIDE"] = "1"

    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vsview version 2>&1")
    return if OS.mac? # unable to run vsview in macOS sandbox

    ENV["COLUMNS"] = "120"
    ENV["QT_QPA_PLATFORM"] = "minimal"
    output_log = testpath/"output.log"
    pid = spawn bin/"vsview", "--no-settings", "--verbose", [:out, :err] => output_log.to_s
    begin
      sleep 10
      assert_match "Plugin integration, finalized", output_log.read
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
