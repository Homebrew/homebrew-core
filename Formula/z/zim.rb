class Zim < Formula
  include Language::Python::Virtualenv

  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/zim-desktop-wiki/zim-desktop-wiki/archive/refs/tags/0.75.2.tar.gz"
  sha256 "79d20946d2c51fb1285b8a80b8afedb39402d6e4f1349ebe4be945318f275493"
  license "GPL-2.0-or-later"
  head "https://github.com/zim-desktop-wiki/zim-desktop-wiki.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7de8af4f17bfe1037320ec5f244d48ebcc19f27ca170113ad00e9d2c485f761"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7de8af4f17bfe1037320ec5f244d48ebcc19f27ca170113ad00e9d2c485f761"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7de8af4f17bfe1037320ec5f244d48ebcc19f27ca170113ad00e9d2c485f761"
    sha256 cellar: :any_skip_relocation, ventura:       "b7de8af4f17bfe1037320ec5f244d48ebcc19f27ca170113ad00e9d2c485f761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e2bf98837d14211336ff07437d707f5e6418f18f9cd0209661a765c7e548ed9"
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  def python3
    "python3.13"
  end

  def install
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
