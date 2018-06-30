class Sfst < Formula
  desc "Toolbox for morphological analysers and other FST-based tools"
  homepage "http://www.cis.uni-muenchen.de/~schmid/tools/SFST/"
  url "http://www.cis.uni-muenchen.de/~schmid/tools/SFST/data/SFST-1.4.7d.tar.gz"
  sha256 "5a13c6a45298197216a6299eb6cdf96595d2036572bb518b9e1c1893cb1a6d5f"
  # dependencies are bison, flex and ncurses, but they are included in MacOS

  def install
    cd "src"
    system "make"
    system "make", "DESTDIR=#{prefix}/", "install"
    system "make", "DESTDIR=#{share}/", "maninstall"
  end

  test do
    # this simple example is from the manual.
    # first compile a simple grammar
    File.write("foo.fst", "Hello")
    system "#{bin}/fst-compiler", "foo.fst", "foo.a"
    assert_true File.file?("foo.a")

    # then parse simple input using that grammar
    require "open3"
    Open3.popen3("#{bin}/fst-mor", "foo.a") do |stdin, stdout, _|
      stdin.write("Hello")
      stdin.close
      expected_output = "reading transducer...\nfinished.\nHello\n"
      actual_output = stdout.read
      assert_equal expected_output, actual_output
    end
  end
end
