class Sfst < Formula
  desc "Toolbox for morphological analysers and other FST-based tools"
  homepage "http://www.cis.uni-muenchen.de/~schmid/tools/SFST/"
  url "http://www.cis.uni-muenchen.de/~schmid/tools/SFST/data/SFST-1.4.7d.tar.gz"
  sha256 "5a13c6a45298197216a6299eb6cdf96595d2036572bb518b9e1c1893cb1a6d5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "74aa99f751d850a1fcdc1cf347406e7137625cdc8010e3dacce972858a5469f7" => :mojave
    sha256 "6c5e1bc0f6e6d78a565b7892767035238957ab80b838b496a039a9174475056f" => :high_sierra
    sha256 "b3c2889ed84c29e3fb4a2d0f89af99631045178ea30227c8b6ffd3f8cdf308d1" => :sierra
    sha256 "96b01f2f7ddfe59b2d0d924d456e5bbd3b2b1ab9b0c909da98a4773a61f63e69" => :el_capitan
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
