class Sfst < Formula
  desc "Toolbox for morphological analysers and other FST-based tools"
  homepage "https://www.cis.uni-muenchen.de/~schmid/tools/SFST/"
  url "https://www.cis.uni-muenchen.de/~schmid/tools/SFST/data/SFST-1.4.7e.tar.gz"
  sha256 "9e1bda84db1575ffb3bea56f3d49898661ad663280c5b813467cd17a7d6b76ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "84cf35e5f7804382eac45103635c4f1584e3c2dbdb675ee1ad432cc47dd5a2a0" => :catalina
    sha256 "a956b48189601556994daa06e47f9b287419de7aecd893912309e05aca32fec0" => :mojave
    sha256 "1036f8a78616f1c3ade380ac0c240dd68598f976cb4d937ef06b88c607a14be3" => :high_sierra
  end

  def install
    cd "src" do
      system "make"
      system "make", "DESTDIR=#{prefix}/", "install"
      system "make", "DESTDIR=#{share}/", "maninstall"
    end
  end

  test do
    require "open3"

    (testpath/"foo.fst").write "Hello"
    system "#{bin}/fst-compiler", "foo.fst", "foo.a"
    assert_predicate testpath/"foo.a", :exist?, "Foo.a should exist but does not!"

    Open3.popen3("#{bin}/fst-mor", "foo.a") do |stdin, stdout, _|
      stdin.write("Hello")
      stdin.close
      expected_output = "reading transducer...\nfinished.\nHello\n"
      actual_output = stdout.read
      assert_equal expected_output, actual_output
    end
  end
end
