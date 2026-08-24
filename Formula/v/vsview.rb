class Vsview < Formula
  include Language::Python::Virtualenv

  desc "Next-generation VapourSynth previewer"
  homepage "https://jaded-encoding-thaumaturgy.github.io/vs-view/"
  url "https://files.pythonhosted.org/packages/0b/f8/b1b6160674b829f88afb5166bc02e58651875b04168ce893fd60b3b1194d/vsview-0.10.3.tar.gz"
  sha256 "c1836271957961afd77a1adc97eb14eadbde705ea30fc49408cc61791e21714c"
  license all_of: [
    "EUPL-1.2",
    all_of: ["MIT", "Apache-2.0", "ISC", "OFL-1.1"], # src/vsview/assets/
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "616f0d4be558af35bd199be61edde2b7d19f9aab9a8c4c3144c30e7e7e3d2e47"
    sha256 cellar: :any, arm64_sequoia: "31e7aebd38736faafe31de36559e53397d609c28b8bd222edd043f15f8527ce7"
    sha256 cellar: :any, arm64_sonoma:  "0003a35ff4c8b49e3ef4af597bc14362cdf4d6c05943875a9da563bf8f8baa48"
    sha256 cellar: :any, sonoma:        "b43ce7cf3f993536573d269fab0e1d65636b91e289cc84383e8e39559a03e58a"
    sha256 cellar: :any, arm64_linux:   "f0ff19e19b40d5fb763a8417911930696d52344ddb8c2343b5fd3c7406663540"
    sha256 cellar: :any, x86_64_linux:  "5295b28f6d675b1efa49f8b6dc9e5b36bea86036f788d7fda799eee8d0cb3d1d"
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
    url "https://files.pythonhosted.org/packages/47/b1/b2b7389b2e0ddac90a1aecbf4a761db8790de85dace7695c01173ed083cc/jh2-5.0.13.tar.gz"
    sha256 "f8c78cffb3a35c4410513c3eb7989de36028c84277c04f07c97909dd94c23a75"
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
    url "https://files.pythonhosted.org/packages/03/1c/836ad34fb18fac781722019100e2bffd81eb9a0011d7a91c434a7094460d/niquests-3.21.0.tar.gz"
    sha256 "5b7d10a05f4c7ed08cede0af74f492ae7a8a5a71291833d029e23365fc3ea80a"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b8/d7/e7bfbc86e9f99ff7807e24de7703f032e9c9ba80bb355cf26e0e9bc5a75e/platformdirs-4.11.3.tar.gz"
    sha256 "66a73d38a849810252df809a3d8bcbda8e26f6c189920e7535ad608a48dbb5ab"
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
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "qh3" do
    url "https://files.pythonhosted.org/packages/72/ae/9d42d6df0ab9a014138332346fd690f7b0be0556861421d2459caec28d6f/qh3-1.9.4.tar.gz"
    sha256 "bd2ea9baf19656c544a48a56a195f2ac257cd973b566f5f2998fa3b7446281a1"
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
    url "https://files.pythonhosted.org/packages/10/f5/b3acd26309eff2c34254ac96f507d44d1f04a00b7f2624c6d038a2cce1f3/urllib3_future-2.24.901.tar.gz"
    sha256 "4913d3ac1b2ce188360d7a5583d8b4152842bff0db98c2b4fdcb57e810db2e7e"
  end

  resource "vapoursynth-fftspectrum-rs" do
    url "https://files.pythonhosted.org/packages/13/56/9771adfbc1195017e887142cf03253316efac3d21d2f7f10900bdcf628df/vapoursynth_fftspectrum_rs-1.0.13.tar.gz"
    sha256 "bd2347222d833d82ba8f3b4e4cf45aea6276b7c48e5c3eb510198520bf15ebe6"
  end

  resource "vsjetengine" do
    url "https://files.pythonhosted.org/packages/56/bb/5ff3436d5e376d6f26a80ba86687e5e820ccb279175643a8c7d6486f9509/vsjetengine-1.6.0.tar.gz"
    sha256 "0bc97430a44e5ad182296bb19e9af3b16e8095120972bef59fc0c911e9be275a"
  end

  resource "vsjetpack" do
    url "https://files.pythonhosted.org/packages/55/38/2df0d240d22ac5523f20ab0f71078b91d703eccc09fd6c028164ad6a1cdf/vsjetpack-2.2.1.tar.gz"
    sha256 "f061cae7c554f5c6ec65d5e397de02a87180a65a271a548cfc3872612a2ccb59"
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
    url "https://files.pythonhosted.org/packages/23/12/b5362535d64acd7ff184816c0e57e3a436b62c01866a47ec9817d59b336b/vsview_comp-0.13.1.tar.gz"
    sha256 "5f8f06461a08313182896b62ef12047cfdc11d7b0d3187dfd327cd3d372a6cb6"
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
    url "https://files.pythonhosted.org/packages/53/a1/714674b53d3a57013730187e027e291c652a25db053e02236798bec49d61/wassima-2.1.3.tar.gz"
    sha256 "fcd6c38be0f909c393da35cb2a993101fcdcff673b8fa8d5da228f73b630d0d0"
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

    ENV["COLUMNS"] = "120"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
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
