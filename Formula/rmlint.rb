class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.4.4.tar.gz"
  sha256 "294708e7c98783a7782df1ed7f6fc79e9036571b7f69f76c5b3455545ce568bc"

  option "with-json-glib", "Add support for reading json caches"
  option "with-libelf", "Add support for finding non-stripped binaries"

  depends_on "glib" => :run
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sphinx-doc" => :build
  depends_on "json-glib" => :optional
  depends_on "libelf" => :optional

  def install
    scons "config"
    scons
    bin.install "rmlint"
    man1.install "docs/rmlint.1.gz"
  end

  test do
    (testpath/"1.txt").write("1")
    (testpath/"2.txt").write("1")
    assert_match(/^# Duplicate(s):$/, shell_output("#{bin}/rmlint"))
  end
end
