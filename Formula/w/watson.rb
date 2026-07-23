class Watson < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to track (your) time"
  homepage "https://jazzband.github.io/Watson/"
  url "https://files.pythonhosted.org/packages/a9/61/868892a19ad9f7e74f9821c259702c3630138ece45bab271e876b24bb381/td-watson-2.1.0.tar.gz"
  sha256 "204384dc04653e0dbe8f833243bb833beda3d79b387fe173bfd33faecdd087c8"
  license "MIT"
  revision 12
  head "https://github.com/jazzband/Watson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55947afc81bc8188c52bc840d869293ecf55d09f32aa6fa1d12b51d4feb9d818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f91c964ae9a7377b5580e3ae5e840d065ed005e531610f396a8b95c8f074e49f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5714f87823b5c989aebbd597ab2ef611fa94b96eabb2539a25e39e4938b1ffa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "339b482c0433db552a1deaf941c5f6eccb5867b99fcf8d5808a4ca72a34fad9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e02450b4d405b1790d070331a422d8c052f5e1e7b39b8be8863c2d22f16d7665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b985ac28647b33d3f4e7f763ef17a5e4ef806e4ef34f91f59057b84f9808460b"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/24/36/7180e7f077c38108945dbbdf60fe04db681c3feb6e96419f8c6dc8723741/requests-2.34.1.tar.gz"
    sha256 "0fc5669f2b69704449fe1552360bd2a73a54512dfd03e65529157f1513322beb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    # Fix to TypeError: argument of type 'NoneType' for `if 'json' in output_format:`
    # Issue ref: https://github.com/jazzband/Watson/issues/512
    inreplace "watson/cli.py", "in output_format:", "in (output_format or ''):"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"watson", shell_parameter_format: :click)
  end

  test do
    system bin/"watson", "start", "foo", "+bar"
    system bin/"watson", "status"
    system bin/"watson", "stop"
    system bin/"watson", "log"
  end
end
