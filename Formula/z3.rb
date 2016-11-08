class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.5.0.tar.gz"
  sha256 "aeae1d239c5e06ac183be7dd853775b84698db1265cb2258e5918a28372d4a0c"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "30e5144988b88537b7b3d63f6eb3a9b0cec3f33fbced0ec6c9eade41a48c0d10" => :sierra
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

    Language::Python.each_python(build) do |python, version|
      system python, "scripts/mk_make.py", "--prefix=#{prefix}", "--python", "--pypkgdir=#{lib}/python#{version}/site-packages", "--staticlib"
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
