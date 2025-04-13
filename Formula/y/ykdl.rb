class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/LifeActor/ykdl"
  url "https://files.pythonhosted.org/packages/f2/27/f4e7616a139c84a04edb7778db2b3cfb77348ab73020ff232b6551fa8bdd/ykdl-1.8.2.tar.gz"
  sha256 "c689b8e4bf303d1582e40d5039539a1a754f7cf897bce73ec57c7e874e354b19"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb541b86eded5d4bcc6262795c769d284a9e3c37f42f70121d43864f4066dc1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14fc581b3aa8b20eea38a546892b72a858dc746e66ac805339e80b30eea0ae03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97ab80854fd7a7802859506993abdacf466114339a6717a7b0a1010542c3f407"
    sha256 cellar: :any_skip_relocation, sonoma:        "724042f1d05d799c130ad4715877f1b30919f7c0b3e8571f3b9158ad12e1dac0"
    sha256 cellar: :any_skip_relocation, ventura:       "2b8f5f155f13edb4eafb86168bf7e4b3d68ad5a5a68538892458e92233f226fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a69f74467e2cf7ce089700c74580f702be503620dab68542b2df565c42b3f247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb541b86eded5d4bcc6262795c769d284a9e3c37f42f70121d43864f4066dc1d"
  end

  depends_on "python@3.13"

  resource "jsengine" do
    url "https://files.pythonhosted.org/packages/bc/0a/1321515de90de02f9c98ac12dfa9763ae93d658ed662261758dc5e902986/jsengine-1.0.7.post1.tar.gz"
    sha256 "2d0d0dcb46d5cb621f21ea1686bdc26a7dc4775607fc85818dd524ba95e0a0fd"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/9b/a5/73697aaa99bb32b610adc1f11d46a0c0c370351292e9b271755084a145e6/m3u8-6.0.0.tar.gz"
    sha256 "7ade990a1667d7a653bcaf9413b16c3eb5cd618982ff46aaff57fe6d9fa9c0fd"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    video_url = "https://v.youku.com/v_show/id_XNTAwNjY3MjU3Mg==.html"
    output = shell_output("#{bin}/ykdl --info #{video_url} 2>&1", 1)
    assert_match "CRITICAL:YKDL", output
    assert_match version.to_s, shell_output("#{bin}/ykdl -h")
  end
end
