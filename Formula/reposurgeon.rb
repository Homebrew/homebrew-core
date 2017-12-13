class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag => "3.43",
      :revision => "a513685ebefd5f5dc78caff6272f5a7d2d692e1d"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bd78fba0b4fc9a47fb10e089b9775c45e9d65bbe9cfbeb1eb975f9a8181c13ce" => :high_sierra
    sha256 "c854e5ad35c59bd1c717f8f232f7e581b2423d80836541156255f44f0de6aecb" => :sierra
    sha256 "38730f4bde6958779efb2f19096f45579920d18e926eedc9adc55311d9b05efa" => :el_capitan
    sha256 "0aaefd3b688bdcfda7a3b53c485c97d5a7bcd50138dd84b9626da15aa07cfe38" => :yosemite
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
    (testpath/".gitconfig").write <<~EOS
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
