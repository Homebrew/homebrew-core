class Sfst < Formula
  desc "Toolbox for morphological analysers and other FST-based tools"
  homepage "http://www.cis.uni-muenchen.de/~schmid/tools/SFST/"
  url "http://www.cis.uni-muenchen.de/~schmid/tools/SFST/data/SFST-1.4.7d.tar.gz"
  sha256 "5a13c6a45298197216a6299eb6cdf96595d2036572bb518b9e1c1893cb1a6d5f"

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
