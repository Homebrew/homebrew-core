class Vsview < Formula
  include Language::Python::Virtualenv

  desc "Next-generation VapourSynth previewer"
  homepage "https://jaded-encoding-thaumaturgy.github.io/vs-view/"
  url "https://files.pythonhosted.org/packages/fc/89/0f1a7a01173c0b8b6fe9c50c987420b3fb39412e01f22730da1468d0c8bd/vsview-0.8.0.tar.gz"
  sha256 "b486e60551a968f6192f574c12e94243f07d31a35c48dd84b14ee21fa2dc4ea1"
  license all_of: [
    "EUPL-1.2",
    all_of: ["MIT", "Apache-2.0", "ISC", "OFL-1.1"], # src/vsview/assets/
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e6068e8a8cef35dfab481ad0cccf1af046c1f33d0c7ea9df902a8f18cd9f44c2"
    sha256 cellar: :any, arm64_sequoia: "f399d08eb983fdec937667c8a29c7689bc12fc29f9e2119443399ff6c8833cee"
    sha256 cellar: :any, arm64_sonoma:  "6214917084596464820a1ea3f13c161bcc96d04b40104601048215ed21d497b5"
    sha256 cellar: :any, sonoma:        "7fb48e8aef91fb3d6b0b53868269403ec850e2427f058ea8d6352bcdc4a6be79"
    sha256 cellar: :any, arm64_linux:   "f442fcf40883fd99bb79a28972a2c29504c2fb5b2712b2a9768122ae0292ba4f"
    sha256 cellar: :any, x86_64_linux:  "cae5ea0dab4b5893f5279ecfbe9ceb60905a6821c84b3316f85a917663bc4420"
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
  depends_on "zstd"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "cryptography"
  end

  pypi_packages package_name:     "vsview[recommended]",
                exclude_packages: %w[cryptography numpy pyside6 pydantic vapoursynth
                                     vapoursynth-bestsource vapoursynth-akarin],
                extra_packages:   %w[jeepney secretstorage] # Linux-only

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
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
    url "https://files.pythonhosted.org/packages/36/cf/ea4ef2920830dea3f5ab2ea4da6fb67724e6dca80ee2553788c3607243d0/jaraco_functools-4.5.0.tar.gz"
    sha256 "3bb5665ea4a020cf78a7040e89154c77edadb3ca74f366479669c5999aa70b03"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jetpytools" do
    url "https://files.pythonhosted.org/packages/13/bb/6c57b9a53f8bc6c4c01c00fe76109f665d55218e581bc987cd00e201e42a/jetpytools-2.2.7.tar.gz"
    sha256 "4063155f3e33283273a899d9b2c80104c6cf0c365abc3aa8c95c9dfd901fa6ec"
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
    url "https://files.pythonhosted.org/packages/d3/ee/9a33c6d343b298ca7faca7d5a25693aca62f7f2553f2f0e6e54f844c3a75/niquests-3.20.0.tar.gz"
    sha256 "dba85ce23ac5052f0a1e1c1cf1c017511a993f906686e8b6c84e0b54818fd1dc"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "qh3" do
    url "https://files.pythonhosted.org/packages/63/4c/caae9fe409e81ebd495e9b2bf1b3121e8bb644898a5e30248acb7e9838cf/qh3-1.9.2.tar.gz"
    sha256 "c6c92f63c2ec292256b5a5ed9345c42344bdaca2e55ec795623987a563aea19c"
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
    url "https://files.pythonhosted.org/packages/d7/33/a1dddc4f816657bc4f02be0d36d859413767a7efb5c1a694a55e112db407/urllib3_future-2.22.900.tar.gz"
    sha256 "3161900c00cf41db90dd3d938c1d14960faab475dd6ca0bf5ecd06112327c714"
  end

  resource "vapoursynth-fftspectrum-rs" do
    url "https://files.pythonhosted.org/packages/13/56/9771adfbc1195017e887142cf03253316efac3d21d2f7f10900bdcf628df/vapoursynth_fftspectrum_rs-1.0.13.tar.gz"
    sha256 "bd2347222d833d82ba8f3b4e4cf45aea6276b7c48e5c3eb510198520bf15ebe6"
  end

  resource "vsjetengine" do
    url "https://files.pythonhosted.org/packages/f6/82/01707a25ef1024b8a0bec834300a5370a7c70327586120058d90b734ce09/vsjetengine-1.4.0.tar.gz"
    sha256 "a4dc1b7a017e8bd4633da6863e13e86f4705bc8389ca44349e94cdb1561b76d6"
  end

  resource "vsjetpack" do
    url "https://files.pythonhosted.org/packages/a6/df/37da0c9b40e29f43d37540e63ad88a4af478fb4807118af8e88e2fb87a0b/vsjetpack-1.5.0.tar.gz"
    sha256 "1c9a410329c60ee0058a1bf6a84b692f85db68154de55d04a80ea43f25a5c1cf"
  end

  resource "vspackrgb" do
    url "https://files.pythonhosted.org/packages/8f/8e/7e936e57640b81da299198266285fa54f1e8f86ff08539d472e626c0b9a7/vspackrgb-1.3.0.tar.gz"
    sha256 "3bb02182be246fc845f08a3ab8d696a13e4f9c20dbd9622b1351eb400dee90b4"
  end

  resource "vsview-cli" do
    url "https://files.pythonhosted.org/packages/f9/34/69c0786564221ea676aa28642484f10e25a0f1a59bda237cecd077f3049f/vsview_cli-1.1.0.tar.gz"
    sha256 "b119bdb559f64bd340afa8f6d0ab63d20cb2a01dc34e8e343391d8862558752b"
  end

  resource "vsview-comp" do
    url "https://files.pythonhosted.org/packages/2c/84/8729242d2104128e46bea7ec42e48c93b5cc56c947922751b64647395c44/vsview_comp-0.10.0.tar.gz"
    sha256 "c222a23dcf9e2b3488ae420da542985974da686877d8c9825e99059f6f4389c6"
  end

  resource "vsview-fftspectrum" do
    url "https://files.pythonhosted.org/packages/2d/8f/4361e35f97c1e7bafadf9f9b27578d909c77af57231e54b90740cab4e546/vsview_fftspectrum-0.2.1.tar.gz"
    sha256 "17e14f8fa276b4a569259fd762cc7c79cce1db20aaa8dcc1b548dd95c3b05e5d"
  end

  resource "vsview-frameprops-extended" do
    url "https://files.pythonhosted.org/packages/42/9c/d5c47089966553efba9b42e8fc26b16e0bcd185815682663bf43aba8ad84/vsview_frameprops_extended-0.2.2.tar.gz"
    sha256 "9cc298f0ac558a9c1004c2b8984e3f8338c9709c88271608ffe3f97bc8d22d81"
  end

  resource "vsview-split-planes" do
    url "https://files.pythonhosted.org/packages/4b/52/2cf4c35349c046882fecc29d49c3a713327f8e8c84dc0adb59546cef81b1/vsview_split_planes-0.2.2.tar.gz"
    sha256 "7b4bccf3b0cf4b4e41b139068251bd667fba2392c6470fb18b6ec8211f8d7b8e"
  end

  resource "wassima" do
    url "https://files.pythonhosted.org/packages/b8/34/68ab01470c1cef170e8370a8a05e598d621d3657bf925b62bc9a18b4509a/wassima-2.1.1.tar.gz"
    sha256 "9c6ad4aa3cfbe91fd75f9eae315ba563bbc7d9d2479aef0c288fa7f1ca3b0c53"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

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
