class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.4.4.tar.gz"
  sha256 "294708e7c98783a7782df1ed7f6fc79e9036571b7f69f76c5b3455545ce568bc"

  depends_on "glib" => :run
  depends_on "scons" => :build        # build system
  depends_on "gettext" => :build      # support for localization
  depends_on "pkg-config" => :build   # manage compile and link flags for libraries
  depends_on "sphinx-doc" => :build   # manpage/documentation generation - Build manpage from docs/rmlint.1.rst
  depends_on "libelf" => :optional    # find non-stripped binaries
  depends_on "json-glib" => :optional # support for reading json caches

  def install
    scons "config"
    scons "-j 4"
    bin.install "rmlint"
    man1.install "docs/rmlint.1.gz"
  end

  test do
    (testpath/"1.txt").write("1")
    (testpath/"2.txt").write("2")
    system bin/"rmlint"
  end
end
