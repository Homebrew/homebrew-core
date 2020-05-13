class Threesdk < Formula
    desc "Software development kit for JumpscaleX"
    homepage "https://sdk.threefold.io/"
    url "https://github.com/threefoldtech/jumpscaleX_core/archive/v10.5.2.tar.gz"
    sha256 "d2ce77a61a198b2cd53f4acce5fd7e5c36c369fc83a05b9f74314530b4f4a175"

    depends_on "python@3.8" => :build
    depends_on "gnu-sed" => :build
    depends_on "upx" => :build

    resource "docopt" do
      url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
      sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
    end

    resource "jedi" do
      url "https://files.pythonhosted.org/packages/e3/5b/65ff9c102d92bf719dfaeff57bc8074d68f26ea480005704a956da995799/jedi-0.17.0.tar.gz"
      sha256 "df40c97641cb943661d2db4c33c2e1ff75d491189423249e989bcea4464f3030"
    end

    resource "parso" do
      url "https://files.pythonhosted.org/packages/fe/24/c30eb4be8a24b965cfd6e2e6b41180131789b44042112a16f9eb10c80f6e/parso-0.7.0.tar.gz"
      sha256 "908e9fae2144a076d72ae4e25539143d40b8e3eafbaeae03c1bfe226f4cdf12c"
    end

    resource "prompt-toolkit" do
      url "https://files.pythonhosted.org/packages/0c/37/7ad3bf3c6dbe96facf9927ddf066fdafa0f86766237cff32c3c7355d3b7c/prompt_toolkit-2.0.10.tar.gz"
      sha256 "f15af68f66e664eaa559d4ac8a928111eebd5feda0c11738b5998045224829db"
    end

    resource "ptpython" do
      url "https://files.pythonhosted.org/packages/ec/00/7db6b203f1cc9ebe316f76078a66feb64e175bde48412baf167d3bdf2ff3/ptpython-2.0.4.tar.gz"
      sha256 "ebe9d68ea7532ec8ab306d4bdc7ec393701cd9bbd6eff0aa3067c821f99264d4"
    end

    resource "Pygments" do
      url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
      sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
    end

    resource "six" do
      url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
      sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
    end

    resource "wcwidth" do
      url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
      sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
    end

    resource "certifi" do
      url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
      sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
    end

    resource "chardet" do
      url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
      sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
    end

    resource "idna" do
      url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
      sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
    end

    resource "requests" do
      url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
      sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
    end

    resource "urllib3" do
      url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
      sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
    end

    resource "altgraph" do
      url "https://files.pythonhosted.org/packages/22/5a/ac50b52581bbf0d8f6fd50ad77d20faac19a2263b43c60e7f3af8d1ec880/altgraph-0.17.tar.gz"
      sha256 "1f05a47122542f97028caf78775a095fbe6a2699b5089de8477eb583167d69aa"
    end

    resource "macholib" do
      url "https://files.pythonhosted.org/packages/0d/fe/61e8f6b569c8273a8f2dd73921738239e03a2acbfc55be09f8793261f269/macholib-1.14.tar.gz"
      sha256 "0c436bc847e7b1d9bda0560351bf76d7caf930fb585a828d13608839ef42c432"
    end

    resource "PyInstaller" do
      url "https://files.pythonhosted.org/packages/3c/c9/c3f9bc64eb11eee6a824686deba6129884c8cbdf70e750661773b9865ee0/PyInstaller-3.6.tar.gz"
      sha256 "3730fa80d088f8bb7084d32480eb87cbb4ddb64123363763cf8f2a1378c1c4b7"
    end

    resource "packaging" do
      url "https://files.pythonhosted.org/packages/65/37/83e3f492eb52d771e2820e88105f605335553fe10422cba9d256faeb1702/packaging-20.3.tar.gz"
      sha256 "3c292b474fda1671ec57d46d739d072bfd495a4f51ad01a055121d81e952b7a3"
    end

    resource "pyparsing" do
      url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
      sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
    end

    resource "pudb" do
      url "https://files.pythonhosted.org/packages/10/dc/a4933487ea8322336d3827c1193fff0ddd8b3a43eeda3f446f163dacc407/pudb-2019.2.tar.gz"
      sha256 "e8f0ea01b134d802872184b05bffc82af29a1eb2f9374a277434b932d68f58dc"
    end

    resource "urwid" do
      url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
      sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
    end

    resource "pytoml" do
      url "https://files.pythonhosted.org/packages/f4/ba/98ee2054a2d7b8bebd367d442e089489250b6dc2aee558b000e961467212/pytoml-0.1.21.tar.gz"
      sha256 "8eecf7c8d0adcff3b375b09fe403407aa9b645c499e5ab8cac670ac4a35f61e7"
    end

    resource "cffi" do
      url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
      sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
    end

    resource "pycparser" do
      url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
      sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
    end

    resource "PyNaCl" do
      url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
      sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
    end

    def install
      ENV["PATH"] += ":/usr/local/bin"
      system 'cd install; version=$(git describe --tags); gsed -i "s/_unreleased_/${version}/" threesdk/__init__.py;'
      system "cd install; pyinstaller 3sdk.spec"
      bin.install "install/dist/3sdk"
    end

    test do
      system bin/"3sdk", "--expert", "container", "list"
    end
end
