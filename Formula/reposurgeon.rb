class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag => "3.43",
      :revision => "a513685ebefd5f5dc78caff6272f5a7d2d692e1d"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e466c365599128dd3cf22a6c0b825d198bc3aca9b0ffa2363405e8074e355d1d" => :high_sierra
    sha256 "54469dad50f8885739c659201f77b49b224de6e09dd4fbb558ca33f85caebc9d" => :sierra
    sha256 "eb28acb491ef786f599c664e41a908ebc08b04bfe32362c18c6e76b6e1a958d3" => :el_capitan
  end

  option "without-cython", "Build without cython (faster compile)"

  depends_on "python" if MacOS.version <= :snow_leopard
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
