class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.4.1.tar.gz"
  sha256 "50967cca12c5c6e1612d0ccf8b6ebf5f99840a783d6cf5216336a2b59c37c0ce"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    revision 2
    sha256 "d925dc49d327be2490db0596411337a0df192658a155699b103ba939c37b3d90" => :el_capitan
    sha256 "17eae04130182bec971555ac61ca9f088dd553d872689b04573c10bf172d68ac" => :yosemite
    sha256 "c24a8cd704b415d6de65985a5113d754fcdc3fbed98ab0e739364354a3d14770" => :mavericks
  end

  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  def install
    if build.without?("python3") && build.without?("python")
      odie "z3: --with-python3 must be specified when using --without-python"
    end

    # This `inreplace` can be removed on next stable release.
    inreplace "scripts/mk_util.py", "dist-packages", "site-packages" if build.stable?

    Language::Python.each_python(build) do |python, version|
      # On next stable release remove the `if` condition and use
      # the first statement in the condition below.
      if build.head?
        system python, "scripts/mk_make.py", "--prefix=#{prefix}", "--python", "--pypkgdir=#{lib}/python#{version}/site-packages", "--staticlib"
      else
        system python, "scripts/mk_make.py", "--prefix=#{prefix}", "--staticlib"
      end
      cd "build" do
        system "make"
        system "make", "install"
      end
    end

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
