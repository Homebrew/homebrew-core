class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/zim-desktop-wiki/zim-desktop-wiki/archive/0.75.1.tar.gz"
  sha256 "ce9d6108566668fe0acdfdce9e899e20a8645ec976d960f2d280b9cfaffdd513"
  license "GPL-2.0-or-later"
  head "https://github.com/zim-desktop-wiki/zim-desktop-wiki.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "38a0b61a4123f51f06fde82e42e67fcabc332be300ad3cc3c53fcfcfc5834b49"
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "pygobject3"
  depends_on "python@3.11"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    python3 = "python3.11"
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_create_path "PYTHONPATH", libexec/site_packages
    resource("pyxdg").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor", python3)
    end

    ENV["XDG_DATA_DIRS"] = libexec/"share"

    zim_setup_install_args = Language::Python.setup_install_args(libexec, python3).reject { |s| s[/single-version/] }
    zim_setup_install_args << "--install-data=#{prefix}"
    system python3, *zim_setup_install_args
    bin.install (libexec/"bin").children
    bin.env_script_all_files libexec/"bin",
                             PYTHONPATH:    ENV["PYTHONPATH"],
                             XDG_DATA_DIRS: [HOMEBREW_PREFIX/"share", libexec/"share"].join(":")
    pkgshare.install "zim"

    # Make the bottles uniform
    inreplace [
      libexec/site_packages/"zim/config/basedirs.py",
      libexec/"vendor"/site_packages/"xdg/BaseDirectory.py",
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
