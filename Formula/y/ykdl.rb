class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/f2/27/f4e7616a139c84a04edb7778db2b3cfb77348ab73020ff232b6551fa8bdd/ykdl-1.8.2.tar.gz"
  sha256 "c689b8e4bf303d1582e40d5039539a1a754f7cf897bce73ec57c7e874e354b19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bfd95765b3413aae9546fe898949ee266661a4d6bf7251ecedfa7e80d3d85d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9669d8abc2e7007ab762d54ac5f46d2c06d6414945f93d676614761290e9042"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6577df8df4b3a354e9457740ae9c97249062195f8db9ea293238ac664aab15d"
    sha256 cellar: :any_skip_relocation, ventura:        "25267a1e6a5b19996364dc210a820182dbd979c802a157fa9f063438b6a5eda9"
    sha256 cellar: :any_skip_relocation, monterey:       "40352d2bfbc62a67104fac49ce087902e0f617b1805106a93d834c6fedf48c60"
    sha256 cellar: :any_skip_relocation, big_sur:        "899a254962e5978a6c267a1fbab79aa69870c19c3d542b46da81fbe9d120b74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcff8c2fb5974a8b76afe84436346f39295e613b9a947e57bab68b8650cd972c"
  end

  depends_on "python@3.11"

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/27/23/97cd1cb5792ece594ec5cf16cc4921f91838c689c82c8078ee442751f8dc/iso8601-2.0.0.tar.gz"
    sha256 "739960d37c74c77bd9bd546a76562ccb581fe3d4820ff5c3141eb49c839fda8f"
  end

  resource "jsengine" do
    url "https://files.pythonhosted.org/packages/bc/0a/1321515de90de02f9c98ac12dfa9763ae93d658ed662261758dc5e902986/jsengine-1.0.7.post1.tar.gz"
    sha256 "2d0d0dcb46d5cb621f21ea1686bdc26a7dc4775607fc85818dd524ba95e0a0fd"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/05/97/e1279c9f025838df264c6643b132a6f3778f8215281fc501644547a821a9/m3u8-3.5.0.tar.gz"
    sha256 "b2eeaa768de574c9d05aad135b1073992927ce0a20b968ebb13f3a183fa92488"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAwNjY3MjU3Mg==.html"
    assert_match version.to_s, shell_output("#{bin}/ykdl -h")
  end
end
