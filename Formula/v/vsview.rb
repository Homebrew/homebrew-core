class Vsview < Formula
  include Language::Python::Virtualenv

  desc "Next-generation VapourSynth previewer"
  homepage "https://jaded-encoding-thaumaturgy.github.io/vs-view/"
  url "https://files.pythonhosted.org/packages/0a/04/f69db3c58e07d6634cbd202d86ce9622ffa07f54d5cec6e99579c86f5b02/vsview-0.11.0.tar.gz"
  sha256 "6d06ffdb12010df1a0992a0cb52b17b588a0a01b2675d08b63f629510d722662"
  license all_of: [
    "EUPL-1.2",
    all_of: ["MIT", "Apache-2.0", "ISC", "OFL-1.1"], # src/vsview/assets/
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "41003909dc6b8f0808c2faf2499e3f30d9bb168c52ddff3a00af00fb6ff9e7db"
    sha256 cellar: :any, arm64_sequoia: "595ce843e4761ee3114fe81c98a300f41e4f190abfaa4fe1c22842065a65260d"
    sha256 cellar: :any, arm64_sonoma:  "a72f81fca13f69382690495471740219777bd2a6f368137612348d57a2b3d16d"
    sha256 cellar: :any, arm64_linux:   "fbdcb30eb97e83e3cc4f46c058c0de6f3a45172e2192928af270132d93ce1212"
    sha256 cellar: :any, x86_64_linux:  "791c441de447f93450fe01424cce87c3b6c9846984001019704bbec2fd206ab9"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "numpy"
  depends_on "pydantic" => :no_linkage
  depends_on "pyside"
  depends_on "python@3.14"
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

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
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
    url "https://files.pythonhosted.org/packages/7f/99/99279c429c0bfe13e109ffb9a622ee297cc27af444b0166da6bc6b0b572c/jetpytools-3.1.1.tar.gz"
    sha256 "2eec2d4dd3959b3a0da8c2c438e84953b5659610107448ed9b4f4708174c7502"
  end

  resource "jh2" do
    url "https://files.pythonhosted.org/packages/c8/85/193d31612e2be4d716ba00aeba608837f7599de3c639be70c40227a3f453/jh2-5.0.14.tar.gz"
    sha256 "101708db41998159295c403f891dce9d8055a8dd98450c605e6eb7c34751543e"
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
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "niquests" do
    url "https://files.pythonhosted.org/packages/21/e0/bf0dfc98ff4fd6dc1f4872972c14688f159013ebecda27c71ccb42bfdff4/niquests-3.21.1.tar.gz"
    sha256 "8ba6ee8712570ae41dfc59ac2ac7e509dcde660c6cc47078b43be423a2f99e64"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/69/b7/802a56eca9f2fac455b8bab5375a2647b0f0e14a2cd63ef077de3c4a7658/platformdirs-4.11.7.tar.gz"
    sha256 "4f41487eeeeeb07f3a6625e61d9bc0ae6809f92d3386dbd74392fbb76108104d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "qh3" do
    url "https://files.pythonhosted.org/packages/b8/8c/3c8f0fbac79d22873d8e54c8ab6a9d9a64f5957ddb22af18ea4dc6044f52/qh3-2.0.3.tar.gz"
    sha256 "546ab2d3193e37e98dfefe5834484e07d0bf531708f21e1a4e227a51510b648f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "urllib3-future" do
    url "https://files.pythonhosted.org/packages/49/ff/e0afc7402601d85fe36ca29480a77df2a6fd22502971783116cfa5470231/urllib3_future-2.24.907.tar.gz"
    sha256 "6565b3cc160a950821953079a6ccd4daa8fd60071a13c9a251576648929f3aa7"
  end

  resource "vapoursynth-fftspectrum-rs" do
    url "https://files.pythonhosted.org/packages/13/56/9771adfbc1195017e887142cf03253316efac3d21d2f7f10900bdcf628df/vapoursynth_fftspectrum_rs-1.0.13.tar.gz"
    sha256 "bd2347222d833d82ba8f3b4e4cf45aea6276b7c48e5c3eb510198520bf15ebe6"
  end

  resource "vsjetengine" do
    url "https://files.pythonhosted.org/packages/10/66/ace34ff3b75ff151c414bbae89646790984f3bbfe569519104fb322fee54/vsjetengine-1.7.0.tar.gz"
    sha256 "386dc930eedee92864d18925459ac80fd68e0ecf9112468ccbe6969fe6504c6f"
  end

  resource "vsjetpack" do
    url "https://files.pythonhosted.org/packages/6a/a1/6cb6f3ae6c8e445b742489c7f34cc29007b3190ab41ca06090e5e3b32e28/vsjetpack-2.2.4.tar.gz"
    sha256 "2022801a199fd32e5e2959290d88ed1926ded865e052b2e0b24daa544fad1406"
  end

  resource "vspackrgb" do
    url "https://files.pythonhosted.org/packages/f4/7f/d487740b694d6e99522301bf594b80492730be77c5ea2902ff528d93122b/vspackrgb-1.4.0.tar.gz"
    sha256 "6f3a227e70c09d9dbc35c5f2500b0d23c7729de8197886c8e511d372d385a5b4"
  end

  resource "vsview-cli" do
    url "https://files.pythonhosted.org/packages/0d/03/17c0c66ff7426d14c9fe33a8066774c97c7f6eb4c01ea07c1102e5656e3e/vsview_cli-1.2.0.tar.gz"
    sha256 "cb983f4436a36f0f561ebc2e5d06280d1c9247564c1bcafc9c53fdf2c9c5417c"
  end

  resource "vsview-comp" do
    url "https://files.pythonhosted.org/packages/09/08/0bd0d2e36ff91dc9a53ae1fea763a7c62a5de49c4b771236e4ae4238aaab/vsview_comp-0.13.2.tar.gz"
    sha256 "6c2126c9eab6d528571a31d757ffd4f3e01cfc31f8ffc40136a625fce485463e"
  end

  resource "vsview-fftspectrum" do
    url "https://files.pythonhosted.org/packages/64/21/0db0d29b5d66b98efeac761b8c1e9208afcfe5eedefe8efb474620983d0d/vsview_fftspectrum-0.2.3.tar.gz"
    sha256 "b48066c57df27c1ad3de441ef6cf51de56e096d331437d3290855fb080c4781d"
  end

  resource "vsview-frameprops-extended" do
    url "https://files.pythonhosted.org/packages/2f/be/b8a6d9a8f769cb6233afb99849cc1fbebab6b5140dfb10e74587aa05e709/vsview_frameprops_extended-0.2.3.post1.tar.gz"
    sha256 "5d7693762318804d7e9bf13223b420d06d4d6b1d064dd8e01f7ef964271d6ea9"
  end

  resource "vsview-split-planes" do
    url "https://files.pythonhosted.org/packages/c6/e3/068fa2c9744e240329e3411ca35ede7a1bc5166da829dc982335f8ce0e15/vsview_split_planes-0.2.4.tar.gz"
    sha256 "b9609c4e2f1a6b84ac6a2eb439d90cf39571028ff8f16f8a867512694dd0069e"
  end

  resource "wassima" do
    url "https://files.pythonhosted.org/packages/5f/92/fe256733440f7c36084ce924f373fbbf709277ddf92262b2295e8caf26d5/wassima-2.1.4.tar.gz"
    sha256 "21bb77253bb8032c05393172c4d2df395f423b7e704538f3b2407f50c032034d"
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
    assert_match version.to_s, shell_output("#{bin}/vsview version")
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
