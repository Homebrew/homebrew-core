class Zim < Formula
  include Language::Python::Virtualenv

  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/zim-desktop-wiki/zim-desktop-wiki/archive/refs/tags/0.75.2.tar.gz"
  sha256 "79d20946d2c51fb1285b8a80b8afedb39402d6e4f1349ebe4be945318f275493"
  license "GPL-2.0-or-later"
  head "https://github.com/zim-desktop-wiki/zim-desktop-wiki.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "201282b70e7324e1a7c21306827b3591dfb99f91f1ae941b9b1f1c3f7fa04e43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "201282b70e7324e1a7c21306827b3591dfb99f91f1ae941b9b1f1c3f7fa04e43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "201282b70e7324e1a7c21306827b3591dfb99f91f1ae941b9b1f1c3f7fa04e43"
    sha256 cellar: :any_skip_relocation, sonoma:         "201282b70e7324e1a7c21306827b3591dfb99f91f1ae941b9b1f1c3f7fa04e43"
    sha256 cellar: :any_skip_relocation, ventura:        "201282b70e7324e1a7c21306827b3591dfb99f91f1ae941b9b1f1c3f7fa04e43"
    sha256 cellar: :any_skip_relocation, monterey:       "201282b70e7324e1a7c21306827b3591dfb99f91f1ae941b9b1f1c3f7fa04e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b97490f127ba70d47cf4d8f841259fa4b432ef74e7d83038a46adbb2624d81"
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  def install
    python3 = "python3.12"
    build_venv = virtualenv_create(buildpath/"venv", python3)
    build_venv.pip_install resource("setuptools")
    ENV.prepend_create_path "PYTHONPATH", build_venv.site_packages

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "setuptools" }
    venv.pip_install buildpath, build_isolation: false
    (bin/"zim").write_env_script libexec/"bin/zim",
                                 XDG_DATA_DIRS: [HOMEBREW_PREFIX/"share", libexec/"share"].join(":")
    share.install (libexec/"share").children
    pkgshare.install "zim"

    # Make the bottles uniform
    inreplace [
      venv.site_packages/"zim/config/basedirs.py",
      venv.site_packages/"xdg/BaseDirectory.py",
      pkgshare/"zim/config/basedirs.py",
    ], "/usr/local", HOMEBREW_PREFIX
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    mkdir_p %w[Notes/Homebrew HTML]
    # Equivalent of (except doesn't require user interaction):
    # zim --plugin quicknote --notebook ./Notes --page Homebrew --basename Homebrew
    #     --text "[[https://brew.sh|Homebrew]]"
    File.write(
      "Notes/Homebrew/Homebrew.txt",
      "Content-Type: text/x-zim-wiki\nWiki-Format: zim 0.4\n" \
      "Creation-Date: 2020-03-02T07:17:51+02:00\n\n[[https://brew.sh|Homebrew]]",
    )
    system bin/"zim", "--index", "./Notes"
    system bin/"zim", "--export", "-r", "-o", "HTML", "./Notes"
    assert_match "Homebrew:Homebrew", (testpath/"HTML/Homebrew/Homebrew.html").read
    assert_match "https://brew.sh|Homebrew", (testpath/"Notes/Homebrew/Homebrew.txt").read
  end
end
