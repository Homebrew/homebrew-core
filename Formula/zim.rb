class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/zim-desktop-wiki/zim-desktop-wiki/archive/0.73.5.tar.gz"
  sha256 "9f983fac9655a61bfe1fa6f9e8cfa59bef099dadfdc4c003913999b184ed1342"
  license "GPL-2.0-or-later"
  head "https://github.com/zim-desktop-wiki/zim-desktop-wiki.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c91e2aa37f2729036860bcfd240c44ceaaf9441a1d6f9b5f5049a5bd55071cc" => :big_sur
    sha256 "f9e5c6e1dcdc0c740d3814078ead9a66ce2c2e4a13936b340b148fc849c500e4" => :catalina
    sha256 "bc624e93da48425929bd0eee61d991ff80c1298ec620bfbf9229bd79170087ae" => :mojave
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
