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
    sha256 "b1e5718025e3f8b7a328eacbe2aed1c622c131be1b42474f28ee688593ec5879" => :big_sur
    sha256 "09dcf154225183feda9a13b8594a05fcc6b903fbc0a68062d6f72dbd4bbf41e5" => :arm64_big_sur
    sha256 "21efbe7ff60736cf669a9b7f2d2cc42b2ba3e2e6bf61d5f5a866731a1f2f57cc" => :catalina
    sha256 "6df51aef68b72ef50bb79fcba986683188fa5653c271135ae2d11c40217d2393" => :mojave
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
