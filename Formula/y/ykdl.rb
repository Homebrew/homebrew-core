class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/LifeActor/ykdl"
  url "https://files.pythonhosted.org/packages/f2/27/f4e7616a139c84a04edb7778db2b3cfb77348ab73020ff232b6551fa8bdd/ykdl-1.8.2.tar.gz"
  sha256 "c689b8e4bf303d1582e40d5039539a1a754f7cf897bce73ec57c7e874e354b19"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcfdd44c710a9891af4829313a096befb361c2708ede5fede7569a7b3f74c7c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "064f73209fcb6b73b9cc7fbb53b6b50af4a409c07f8ae1cf4ec03b625ecea5fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e596fdb73331b055055570d42b4199feeb9591dc7ad6b2052abe1ac0141b828"
    sha256 cellar: :any_skip_relocation, sonoma:        "064f73209fcb6b73b9cc7fbb53b6b50af4a409c07f8ae1cf4ec03b625ecea5fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "064f73209fcb6b73b9cc7fbb53b6b50af4a409c07f8ae1cf4ec03b625ecea5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcfdd44c710a9891af4829313a096befb361c2708ede5fede7569a7b3f74c7c5"
  end

  depends_on "python@3.14"

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
