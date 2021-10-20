class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/zim-desktop-wiki/zim-desktop-wiki/archive/0.74.2.tar.gz"
  sha256 "ab3e06f2d4f48037709c7c1e3b236b4e6cdaa9ad69537ad516771b28e07f3732"
  license "GPL-2.0-or-later"
  head "https://github.com/zim-desktop-wiki/zim-desktop-wiki.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "cac5007e5857504e22b3021aa8111798ffacf6a34493210b09d21337d4da81dc"
    sha256 cellar: :any_skip_relocation, catalina:     "cac5007e5857504e22b3021aa8111798ffacf6a34493210b09d21337d4da81dc"
    sha256 cellar: :any_skip_relocation, mojave:       "cac5007e5857504e22b3021aa8111798ffacf6a34493210b09d21337d4da81dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1a1e41993dfd0df0bd0396d53c09626df2047106362149db0e25775ff5732355"
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
    python_version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{python_version}/site-packages"
    resource("pyxdg").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
    end
    ENV["XDG_DATA_DIRS"] = libexec/"share"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{python_version}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "./setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin",
      PYTHONPATH:    ENV["PYTHONPATH"],
      XDG_DATA_DIRS: ["#{HOMEBREW_PREFIX}/share", libexec/"share"].join(":")
    pkgshare.install "zim"
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
