class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag => "3.42",
      :revision => "885502d6c8bebd4efcf680babb28d7bc4e464a2f"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e34761c579d091ae9448b794f2d50448a21f4da8515acf0bc12685f8836cc3f" => :sierra
    sha256 "6de5b68703983ac4e6210e69ee5b2014aa5d0c24778ba946dca43ba370cf4158" => :el_capitan
    sha256 "761f69aa74c3a931ff8f7affdce5848251a5d71d5b082dbba79bd5e444cc0997" => :yosemite
  end

  option "without-cython", "Build without cython (faster compile)"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "cython" => [:build, :recommended]

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"

    if build.with? "cython"
      pyincludes = Utils.popen_read("python-config --cflags").chomp
      pylib = Utils.popen_read("python-config --ldflags").chomp
      system "make", "install-cyreposurgeon", "prefix=#{prefix}",
                     "CYTHON=#{Formula["cython"].opt_bin}/cython",
                     "pyinclude=#{pyincludes}", "pylib=#{pylib}"
    end
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
