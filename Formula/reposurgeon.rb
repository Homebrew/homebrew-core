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

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b7/67/7e2a817f9e9c773ee3995c1e15204f5d01c8da71882016cac10342ef031b/Cython-0.25.2.tar.gz"
    sha256 "f141d1f9c27a07b5a93f7dc5339472067e2d7140d1c5a9e20112a5665ca60306"
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
