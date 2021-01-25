class Sfst < Formula
  desc "Toolbox for morphological analysers and other FST-based tools"
  homepage "https://www.cis.uni-muenchen.de/~schmid/tools/SFST/"
  url "https://www.cis.uni-muenchen.de/~schmid/tools/SFST/data/SFST-1.4.7f.zip"
  sha256 "31f331a1cc94eb610bcefc42b18a7cf62c55f894ac01a027ddff29e2a71cc31b"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(%r{href=.*?data/SFST[._-]v?(\d+(?:\.\d+)+[a-z]*)\.[tz]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "303e686c5216a73e74ef954e01dbce83b878531ad18df80cb7a29c0c03cd9138" => :big_sur
    sha256 "1a327a02964854d8ba50b22f12d3197535bc65902f154971e901974ef0b43556" => :arm64_big_sur
    sha256 "d8c1b35f23af28cfab56a28664109b18e8b0f551f2f680ecfe2fee94cce6224c" => :catalina
    sha256 "d2fc1beee93f11a89ec9dd1762d6eacf393e6b21752d5d0806deeed5aab8f014" => :mojave
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
      expected_output = "Hello\n"
      actual_output = stdout.read
      assert_equal expected_output, actual_output
    end
  end
end
