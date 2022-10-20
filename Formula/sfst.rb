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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9f9ef199fdf0cd03080197135ee96d9ee50cd0229d602511923b0d53ec9a2ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a327a02964854d8ba50b22f12d3197535bc65902f154971e901974ef0b43556"
    sha256 cellar: :any_skip_relocation, monterey:       "8e15e931308b0cb73a1c09a03cca8cb1b6b0e4ac54a678b8369dc0d40780fb2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "303e686c5216a73e74ef954e01dbce83b878531ad18df80cb7a29c0c03cd9138"
    sha256 cellar: :any_skip_relocation, catalina:       "d8c1b35f23af28cfab56a28664109b18e8b0f551f2f680ecfe2fee94cce6224c"
    sha256 cellar: :any_skip_relocation, mojave:         "d2fc1beee93f11a89ec9dd1762d6eacf393e6b21752d5d0806deeed5aab8f014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af25d44ef848916d9a64bebf152b07cae7d697c1b5b8b1c2368ffa115d9e53ac"
  end

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
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

      # On Linux, the prompts are also captured in the output
      expected_output = "analyze> Hello\n" + expected_output + "analyze> " if OS.linux?

      actual_output = stdout.read
      assert_equal expected_output, actual_output
    end
  end
end
