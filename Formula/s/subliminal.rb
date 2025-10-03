class Subliminal < Formula
  include Language::Python::Virtualenv

  desc "Library to search and download subtitles"
  homepage "https://subliminal.readthedocs.io"
  url "https://files.pythonhosted.org/packages/f9/d1/f55d55bf7d585f6d749b60479b4f405de0d8805324d83c598ee3d540df79/subliminal-2.4.0.tar.gz"
  sha256 "73df6d1940166ef0e2cdeb4f8d655a4afe1082d481ec090ad2a9e66b1a1621fc"
  license "MIT"
  head "https://github.com/Diaoul/subliminal.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ffeb18bfc19b0b565e51f3f538e2221b8e1dbf15bfb8634376630301c83b8876"
    sha256 cellar: :any,                 arm64_sequoia: "44b7e56396000cc9e645619408e589d2da11ed6cccb3108944326ba2f6527eb8"
    sha256 cellar: :any,                 arm64_sonoma:  "fffd967abacc525827f2cb9559283fb4af68349d0d57d99b21191d07d7d0ec33"
    sha256 cellar: :any,                 arm64_ventura: "ac1c7261e5e6a2786acf6b5b0c9e0f6b4d913ff1dbff63bad89f5d47b7fee0dd"
    sha256 cellar: :any,                 sonoma:        "0400fa0ea9530919e9edfe038bed5c2d1bfea64bb07bc11672c1fa3d9df0c7d3"
    sha256 cellar: :any,                 ventura:       "003d43d8c3d8bad8a6d586c5f2a3bb9f623d2111c1d977ba1431a917787758be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2ab54d3ea4ec8b71d37e928b95de694199dd90511fb1eef3ccca1ce333d414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f677db3683d441e0cf6fddf05e68f903e3aeadc7d9609cbe2935732e57b002d2"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/85/2e/3e5079847e653b1f6dc647aa24549d68c6addb4c595cc0d902d1b19308ad/beautifulsoup4-4.13.5.tar.gz"
    sha256 "5e70131382930e7c3de33450a2f54a63d5e4b19386eab43a5b34d594268f3695"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/b9/9f/1f917934da4e07ae7715a982347e3c2179556d8a58d1108c5da3e8f09c76/click_option_group-0.5.7.tar.gz"
    sha256 "8dc780be038712fc12c9fecb3db4fe49e0d0723f9c171d7cda85c20369be693c"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e8/07/2257f13f9cd77e71f62076d220b7b59e1f11a70b90eb1e3ef8bdf0f14b34/dogpile_cache-1.4.0.tar.gz"
    sha256 "b00a9e2f409cf9bf48c2e7a3e3e68dac5fa75913acbf1a62f827c812d35f3d09"
  end

  resource "enzyme" do
    url "https://files.pythonhosted.org/packages/6e/d8/a390f96ac0ccc33ca1c0e5c9cb9fc73f0623117e310594b6bc3be87005de/enzyme-0.5.2.tar.gz"
    sha256 "7cf779148d9e66eb2838603eace140c53c3cefc8b8fe5d4d5a03a5fb5d57b3c1"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/d0/07/5a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cd/guessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "knowit" do
    url "https://files.pythonhosted.org/packages/98/aa/827183a60bdea775d408240dfa20d3ff46b110f0d82157a4419c7eb1aac6/knowit-0.5.11.tar.gz"
    sha256 "9045d6640b1bd00fcc49f2f7e81992cdc6c7279767db199d7f3b63e2f5007b58"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "pymediainfo" do
    url "https://files.pythonhosted.org/packages/4d/80/80a6fb21005b81e30f6193d45cba13857df09f5d483e0551fa6fbb3aaeed/pymediainfo-7.0.1.tar.gz"
    sha256 "0d5df59ecc615e24c56f303b8f651579c6accab7265715e5d429186d7ba21514"
  end

  resource "pysubs2" do
    url "https://files.pythonhosted.org/packages/31/4a/becf78d9d3df56e6c4a9c50b83794e5436b6c5ab6dd8a3f934e94c89338c/pysubs2-1.8.0.tar.gz"
    sha256 "3397bb58a4a15b1325ba2ae3fd4d7c214e2c0ddb9f33190d6280d783bb433b20"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/f2/06/24c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296/rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "srt" do
    url "https://files.pythonhosted.org/packages/66/b7/4a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030/srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/2a/5f/8418daad5c353300b7661dd8ce2574b0410a6316a8be650a189d5c68d938/stevedore-5.5.0.tar.gz"
    sha256 "d31496a4f4df9825e1a1e4f1f74d19abb0154aff311c3b376fcc89dae8fccd73"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "trakit" do
    url "https://files.pythonhosted.org/packages/59/0c/28f6a6f60cf58f383142c2daf73dd9b97cd8436e71f121a4bcb35e1b459e/trakit-0.2.5.tar.gz"
    sha256 "d7e530ed82906eeadf7982d6a357883ae0490f34bbd18f8232b8fc5f250a4ae7"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"subliminal", shell_parameter_format: :click)
  end

  test do
    (testpath/".config").mkpath
    system bin/"subliminal", "download", "-l", "en",
               "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
    assert_path_exists testpath/"The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.en.srt"
  end
end
