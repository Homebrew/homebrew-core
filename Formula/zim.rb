class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/jaap-karssenberg/zim-desktop-wiki/archive/0.73.2.tar.gz"
  sha256 "f002e63d7c131e317225c2912d5cc2065da90448f7ebd330ad4931a57fa45eda"
  license "GPL-2.0"
  head "https://github.com/jaap-karssenberg/zim-desktop-wiki.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf934b65101cd8587b6e4767b27133a342c62cd0cb240cdf3b54ce73f0420088" => :catalina
    sha256 "bf934b65101cd8587b6e4767b27133a342c62cd0cb240cdf3b54ce73f0420088" => :mojave
    sha256 "bf934b65101cd8587b6e4767b27133a342c62cd0cb240cdf3b54ce73f0420088" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "pygobject3"
  depends_on "python@3.8"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    python_version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{python_version}/site-packages"
    resource("pyxdg").stage do
      system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
    end
    ENV["XDG_DATA_DIRS"] = libexec/"share"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{python_version}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "./setup.py", "install", "--prefix=#{libexec}"
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
