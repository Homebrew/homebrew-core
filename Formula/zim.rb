class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/zim-desktop-wiki/zim-desktop-wiki/archive/0.74.3.tar.gz"
  sha256 "4a5cff2f8bf99a89f9acaf1368df2ab711edee8d19dcbf3c4b4aeeba89e808aa"
  license "GPL-2.0-or-later"
  head "https://github.com/zim-desktop-wiki/zim-desktop-wiki.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df1dd11baa2693ecf8686ea4fab05cc30b1475dbc16d8c758a6473b751c345fb"
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  def install
    python3 = which("python3")
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3")
    resource("pyxdg").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor")
    end
    ENV["XDG_DATA_DIRS"] = libexec/"share"
    system python3, "./setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin",
      PYTHONPATH:    ENV["PYTHONPATH"],
      XDG_DATA_DIRS: [HOMEBREW_PREFIX/"share", libexec/"share"].join(":")
    pkgshare.install "zim"

    # Make the bottles uniform
    inreplace [
      libexec/Language::Python.site_packages("python3")/"zim/config/basedirs.py",
      libexec/"vendor"/Language::Python.site_packages("python3")/"xdg/BaseDirectory.py",
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
    system "#{bin}/zim", "--index", "./Notes"
    system "#{bin}/zim", "--export", "-r", "-o", "HTML", "./Notes"
    system "grep", '<a href="https://brew.sh".*Homebrew</a>', "HTML/Homebrew/Homebrew.html"
  end
end
