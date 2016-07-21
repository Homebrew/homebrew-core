class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "http://www.catb.org/~esr/reposurgeon/reposurgeon-3.37.tar.xz"
  sha256 "563dfffd71baa45a70796260f7851c00f9b47960678e0c7e81b00edfc9935a91"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a307933a77b32ebf28fecf18257218a4d6123f91d0f467b87b55aa47d9088d3" => :el_capitan
    sha256 "b2f4f51daf0b9a39fdc3be128e394bb6e3dcb40cef54cd99b8d6e2170d037a33" => :yosemite
    sha256 "21220d00b6d6ccff9293e6c8517108f5efbc8abd428c188295c2b01a54bf3323" => :mavericks
  end

  option "without-cython", "Build without cython (faster compile)"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz"
    sha256 "84808fda00508757928e1feadcf41c9f78e9a9b7167b6649ab0933b76f75e7b9"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"

    if build.with? "cython"
      resource("Cython").stage do
        system "python", *Language::Python.setup_install_args(buildpath/"vendor")
      end
      ENV.prepend_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"
      system "make", "install-cyreposurgeon", "prefix=#{prefix}",
             "CYTHON=#{buildpath}/vendor/bin/cython",
             "pyinclude=" + `python-config --cflags`.chomp,
             "pylib=" + `python-config --ldflags`.chomp
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
