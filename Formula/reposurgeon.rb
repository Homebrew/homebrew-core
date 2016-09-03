class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag => "3.39",
      :revision => "bad2af083903e74775e0c63f0705a6c20f854462"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "618d602c3ff11a790fe996296e0eaa19a4f94ef264a780ce82f2c487b98eead8" => :el_capitan
    sha256 "e298b2ce653106d257ab82e8c4401b3417382deb7493ec4311941886d3765988" => :yosemite
    sha256 "e7aaa1b3a20df34ddc9b9d1ecc0cc7b440a9c95c1a087c10d7b2fac8020adaec" => :mavericks
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
