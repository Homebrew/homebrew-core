class Soundpipe < Formula
  desc "Lightweight music DSP library"
  homepage "https://paulbatchelor.github.io/proj/soundpipe.html"
  url "https://github.com/PaulBatchelor/soundpipe/archive/v1.7.0.tar.gz"
  sha256 "2d6f6b155ad93d12f59ae30e2b0f95dceed27e0723147991da6defc6d65eadda"

  bottle do
    cellar :any_skip_relocation
    sha256 "77a13450033a093276c66a292ad3944174a50509d7238d138a7329fcf3e8faa4" => :mojave
    sha256 "4f0b6f6a15345ce24137c640ab6c7a3a6a8c27d2391db3349672008feaaf67e3" => :high_sierra
    sha256 "2d4accbb857729269d28c0812f08bb329258622f2ef584e37f48c5a846001804" => :sierra
    sha256 "134c366d9bc06559fcfd2fb3a9aadf779bd974da23884b3b87eb9edac9dd22c9" => :el_capitan
  end

  depends_on "libsndfile"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples", "test"
  end

  test do
    system ENV.cc, "#{pkgshare}/examples/ex_osc.c", "-o", "test", "-L#{lib}",
                   "-L#{lib}", "-lsndfile", "-lsoundpipe"
    system "./test"
    assert_predicate testpath/"test.wav", :exist?
  end
end
