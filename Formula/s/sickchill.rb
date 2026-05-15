class Sickchill < Formula
  include Language::Python::Virtualenv

  desc "Automatic Video Library Manager for TV Shows"
  homepage "https://sickchill.github.io"
  url "https://files.pythonhosted.org/packages/31/fc/337b2989dc67bbb505cea34a05c029cbba3056311177586835f704ddc13a/sickchill-2024.3.1.tar.gz"
  sha256 "e7079bb77b415eb6697a63d9018db1ad317d06ad285d0d77893747cbf000aa17"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/SickChill/SickChill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba5fc00fd7b2a75439afa6f35e1890d028e2b6386dbc018171fae68154cdda6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58c1a285accbcf497caaf0f1275b108eff1f2ee8b6304da48b8de5d71af17f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15ad242781c982f18c35b0d425e7e6c3ef4cf67482a2649caf366fef61474496"
    sha256 cellar: :any_skip_relocation, sonoma:        "a775d8f7948a2142c4c0092cd716bb462775ff6d52c4cc41fffd5ec0d2238653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "517c859568c153b891bd68e7cb50a27ad7c96cad4ebe82a95aac1f9fa1dfeeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955834d16fdce9c874c563f30adc8afd9b961f175a0b7b5d205673f56a2baadc"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography],
                extra_packages:   "setuptools"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "beekeeper-alt" do
    url "https://files.pythonhosted.org/packages/28/68/b1c59d68275715e5174c0ec0185d3ceca3223933a6a35cda31389438e545/beekeeper-alt-2022.9.3.tar.gz"
    sha256 "18addaa163febd69a9e1ec4ec4dddc210785c94c6c1f9b2bcb2a73451b2f23e3"
  end

  resource "bencode-py" do
    url "https://files.pythonhosted.org/packages/e8/6f/1fc1f714edc73a9a42af816da2bda82bbcadf1d7f6e6cae854e7087f579b/bencode.py-4.0.0.tar.gz"
    sha256 "2a24ccda1725a51a650893d0b63260138359eaa299bb6e7a09961350a2a6e05c"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/58/3a/0cbeb04ea57d2493f3ec5a069a117ab467f85e4a10017c6d854ddcbff104/cachecontrol-0.14.3.tar.gz"
    sha256 "73e7efec4b06b20d9267b441c1f733664f989fb8688391b670ca812d70795d11"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "cinemagoer" do
    url "https://files.pythonhosted.org/packages/06/de/3aa6eb738b5c5e39f1909bc080a392842841f9af866edb960de2f22af53c/cinemagoer-2023.5.1.tar.gz"
    sha256 "5ce1d77ae6546701618f11e5b1556a19d18edecad1b6d7d96973ec34941b18f2"

    # Replace `pkgutil.find_loader` removed in 3.14: https://github.com/cinemagoer/cinemagoer/pull/543
    patch do
      url "https://github.com/cinemagoer/cinemagoer/commit/fec0b1a0f90e2d6201f6fa5fd429f13d9b7a747d.patch?full_index=1"
      sha256 "a9f225c42d011f07e0aabb9b29f19c666f8808206787d7e53f9d56df4d749edd"
    end
    # Backport https://github.com/cinemagoer/cinemagoer/commit/88a86cdacc7737d0fcfe299ad7a2e9b365ff379c and
    # https://github.com/cinemagoer/cinemagoer/commit/cb4b61c3be3d7ed0bfc4f3cb506628c3cbb59828
    patch :DATA
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "deluge-client" do
    url "https://files.pythonhosted.org/packages/f1/53/d6672ad7b44190d578ce7520822af34e7119760df9934cad4d730b0592a2/deluge-client-1.10.2.tar.gz"
    sha256 "3881aee3c4e0ca9dd8a56b710047b837e1d087a83e421636a074771f92a9f1b5"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "enzyme" do
    url "https://files.pythonhosted.org/packages/dd/99/e4eee822d9390ebf1f63a7a67e8351c09fb7cd75262e5bb1a5256898def9/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "gntp" do
    url "https://files.pythonhosted.org/packages/c4/6c/fabf97b5260537065f32a85930eb62776e80ba8dcfed78d4247584fd9aa9/gntp-1.0.3.tar.gz"
    sha256 "f4a4f2009ecb8bb41a1aaddd5fb7c03087b2a14cac2c03af029ba04b9166dae0"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/03/b8/704d753a5a45507a7aab61f18db9509302ed3d0a27ac7e0359ec2905b1a6/greenlet-3.2.4.tar.gz"
    sha256 "0dca0d95ff849f9a364385f36ab49f50065d76964944638be9691e1832e9f86d"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/d0/07/5a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cd/guessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "jsonrpclib-pelix" do
    url "https://files.pythonhosted.org/packages/79/21/51a59adb17c2aa27ec3cef8787485df66e06c29f08e19a9d554e45b8f56d/jsonrpclib_pelix-0.4.3.4.tar.gz"
    sha256 "e82d6f4da907a7d111ef93fd2361c8c20b79d248be4fe99678e08626aa8fcbef"
  end

  resource "kodipydent-alt" do
    url "https://files.pythonhosted.org/packages/dd/77/6695c399c31ffca5efa10eef3d07fd2b6b24176260477a909d35f0fc1a0b/kodipydent-alt-2022.9.3.tar.gz"
    sha256 "61fc4e5565646a799c783bcf5ae7503223513906e3242bff2ecc8aa66dc80826"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/42/f8/b2ae8bf5f28f9b510ae097415e6e4cb63226bb28d7ee01aec03a755ba03b/markdown2-2.5.4.tar.gz"
    sha256 "a09873f0b3c23dbfae589b0080587df52ad75bb09a5fa6559147554736676889"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/4d/f2/bfb55a6236ed8725a96b0aa3acbd0ec17588e6a2c3b62a93eb513ed8783f/msgpack-1.1.2.tar.gz"
    sha256 "3b60763c1373dd60f398488069bcdc703cd08a711477b5d480eecc9f9626f47e"
  end

  resource "new-rtorrent-python" do
    url "https://files.pythonhosted.org/packages/18/c6/67a7afff87d09baa7f43f35e94722a5affc4f0f9bd54671cf02008d9c6df/new-rtorrent-python-1.0.1a0.tar.gz"
    sha256 "7a9319d6006b98bab66e68fbd79ec353c81c6e1aea2197a4e9097fd2760d3cfb"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "profilehooks" do
    url "https://files.pythonhosted.org/packages/18/5a/c69fdf542b730c74b9de1cc2cc02692cd5d6a34a9d95e29217262937f91e/profilehooks-1.13.0.tar.gz"
    sha256 "54a541cad49ddccee97b61a617404d7d736bf0bf79d36fbe2ac7caa3a1d9daaf"
  end

  resource "putio-py" do
    url "https://files.pythonhosted.org/packages/a6/2a/52bc4e441b680f3d50921e7142d54c8ff39a04cc13cfa1f2aca8301b24c6/putio_py-8.8.0.tar.gz"
    sha256 "f9a40959f730d0af9c6fe5c9f1dae123a4cd6b2a82f57928a1890b05fb73b4c2"
  end

  resource "pynma" do
    url "https://files.pythonhosted.org/packages/6e/94/37a7ee7b0b8adec69797c3ac1b9a158f6b1ecb608bfe289d155c3b4fc816/PyNMA-1.0.tar.gz"
    sha256 "f90a7f612d508b628daf022068967d2a103ba9b2355b53df12600b8e86ce855b"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/c1/d4/1067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085/pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
  end

  resource "pysrt" do
    url "https://files.pythonhosted.org/packages/31/1a/0d858da1c6622dcf16011235a2639b0a01a49cecf812f8ab03308ab4de37/pysrt-1.1.2.tar.gz"
    sha256 "b4f844ba33e4e7743e9db746492f3a193dc0bc112b153914698e7c1cdeb9b0b9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "python-twitter" do
    url "https://files.pythonhosted.org/packages/59/63/5941b988f1a119953b046ae820bc443ada3c9e0538a80d67f3938f9418f1/python-twitter-3.5.tar.gz"
    sha256 "45855742f1095aa0c8c57b2983eee3b6b7f527462b50a2fa8437a8b398544d90"
  end

  resource "python3-fanart" do
    url "https://files.pythonhosted.org/packages/2e/55/d09b26a5c3bc41e9b92cba5342f1801ea9e8c1bec0862a428401e24dfd19/python3-fanart-2.0.0.tar.gz"
    sha256 "8bfb0605ced5be0123c9aa82c392e8c307e9c65bff47d545d6413bbb643a4a74"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "qbittorrent-api" do
    url "https://files.pythonhosted.org/packages/d6/a9/88fce9b8c5e79bac74b0e9624ec8af2da8280dddc87f91298178aafb7759/qbittorrent_api-2024.12.71.tar.gz"
    sha256 "4bb62ac075826d47529de562896bd97fe8527d2f55851ac3611d7b221c4507e2"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/26/3f/3118a797444e7e30e784921c4bfafb6500fb288a0c84cb8c32ed15853c16/rarfile-4.2.tar.gz"
    sha256 "8e1c8e72d0845ad2b32a47ab11a719bc2e41165ec101fd4d3fe9e92aa3f469ef"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/f2/06/24c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296/rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/fd/3a/aec9b02217bb79b87bbc1a21bc6abc51e3d5dcf65c30487ac96c0908c722/Send2Trash-1.8.3.tar.gz"
    sha256 "b18e7a3966d99871aefeb00cfbcfdced55ce4871194810fc71f4aa484b953abf"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/f0/f2/840d7b9496825333f532d2e3976b8eadbf52034178aac53630d09fe6e1ef/sqlalchemy-2.0.44.tar.gz"
    sha256 "0ae7454e1ab1d780aee69fd2aae7d6b8670a581d8847f2d1e0f7ddfbf47e5a22"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/2a/5f/8418daad5c353300b7661dd8ce2574b0410a6316a8be650a189d5c68d938/stevedore-5.5.0.tar.gz"
    sha256 "d31496a4f4df9825e1a1e4f1f74d19abb0154aff311c3b376fcc89dae8fccd73"
  end

  resource "subliminal" do
    url "https://files.pythonhosted.org/packages/dd/3a/ac02011988ad013f24a11cb6123a7ff9e17a75369964c7edd9f64bfea80f/subliminal-2.1.0.tar.gz"
    sha256 "c6439cc733a4f37f01f8c14c096d44fd28d75d1f6f6e2d1d1003b1b82c65628b"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "timeago" do
    url "https://files.pythonhosted.org/packages/5f/88/8dac5496354650972434966ba570a4a824fafed43471cf190faea4b085fc/timeago-1.0.16-py3-none-any.whl"
    sha256 "9b8cb2e3102b329f35a04aa4531982d867b093b19481cfbb1dac7845fa2f79b0"
  end

  resource "tmdbsimple" do
    url "https://files.pythonhosted.org/packages/a1/87/3309cb03df1c9f9895fccd87e9875050f19e2cfec5a50b9d72e50d420fc8/tmdbsimple-2.9.1.tar.gz"
    sha256 "636eaaaec82027929e8a91c2166e01f552ec63f869bf1fcd65aa561b705c7464"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/09/ce/1eb500eae19f4648281bb2186927bb062d2438c2e5093d1360391afd2f90/tornado-6.5.2.tar.gz"
    sha256 "ab53c8f9a0fa351e2c0741284e06c7a45da86afb544133201c5cc8578eb076a0"
  end

  resource "tus-py" do
    url "https://files.pythonhosted.org/packages/54/3c/266c0aadca8969b8f4832e4975a86afe9c869b3ee6918a408b03619746d6/tus.py-1.3.4.tar.gz"
    sha256 "b80feda87700aae629eb19dd98cec68ae520cd9b2aa24bd0bab2b777be0b4366"
  end

  resource "tvdbsimple" do
    url "https://files.pythonhosted.org/packages/73/7d/b8e4d5c5473d6f9a492bf30916fdbf96f06034e6d23fde31ccb86704e41c/tvdbsimple-1.0.6.tar.gz"
    sha256 "a8665525fa8b7aaf1e15fc3eec18b6f181582e25468830f300ab3809dbe948fe"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/9b/21/40a249498eee5a244a017582c06c0af01851179e2617928063a3d628bc8f/validators-0.22.0.tar.gz"
    sha256 "77b2689b172eeeb600d9605ab86194641670cdb73b60afd577142a9397873370"
  end

  resource "win-inet-pton" do
    url "https://files.pythonhosted.org/packages/d9/da/0b1487b5835497dea00b00d87c2aca168bb9ca2e2096981690239e23760a/win_inet_pton-1.1.0.tar.gz"
    sha256 "dd03d942c0d3e2b1cf8bab511844546dfa5f74cb61b241699fa379ad707dea4f"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/6a/aa/917ceeed4dbb80d2f04dbd0c784b7ee7bba8ae5a54837ef0e5e062cd3cfb/xmltodict-1.0.2.tar.gz"
    sha256 "54306780b7c2175a3967cad1db92f218207e5bc1aba697d887807c0fb68b7649"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"sickchill", "--datadir", var/"sickchill", "--quiet", "--nolaunch"]
    keep_alive true
    working_dir var/"sickchill"
  end

  test do
    port = free_port.to_s
    pid = spawn bin/"sickchill", "--port", port, "--datadir", testpath, "--nolaunch"
    sleep 30
    assert_path_exists testpath/"config.ini"
    assert_path_exists testpath/"sickchill.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

__END__
diff --git a/imdb/parser/http/piculet.py b/imdb/parser/http/piculet.py
index d0c2b7b..806c9f0 100644
--- a/imdb/parser/http/piculet.py
+++ b/imdb/parser/http/piculet.py
@@ -32,7 +32,7 @@ from argparse import ArgumentParser
 from collections import deque
 from functools import partial
 from operator import itemgetter
-from pkgutil import find_loader
+from importlib.util import find_spec

 __version__ = '1.2b1'

@@ -202,7 +202,7 @@ def html_to_xhtml(document, omit_tags=None, omit_attrs=None):
 # sigalias: XPathResult = Union[Sequence[str], Sequence[Element]]


-_USE_LXML = find_loader('lxml') is not None
+_USE_LXML = find_spec('lxml') is not None
 if _USE_LXML:
     from lxml import etree as ElementTree
     from lxml.etree import Element
