class Sfst < Formula
  desc "Toolbox for morphological analysers and other FST-based tools"
  homepage "https://www.cis.uni-muenchen.de/~schmid/tools/SFST/"
  url "https://www.cis.uni-muenchen.de/~schmid/tools/SFST/data/SFST-1.4.7g.zip"
  sha256 "5f3ab2d8190dc931813b5ba3cf94c72013cce7bf03e16d7fb2eda86bd99ce944"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(%r{href=.*?data/SFST[._-]v?(\d+(?:\.\d+)+[a-z]*)\.[tz]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "106a7c45224fb209f3f3edffe1a31e82076469489a757ee2dd5cda9c3a8923c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0926f2435695386b9c21b31c1d4c3feaea5468095c6138e73761e8f350a3226a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27d6b2f85647df82d36dc6f15bfe23a11430d7b1904b8d76326b069f968b5529"
    sha256 cellar: :any_skip_relocation, ventura:        "421805971042457553e42fd13f7d635a5b0cce6ef1de9cd5cf4fd73689394e9a"
    sha256 cellar: :any_skip_relocation, monterey:       "68080e57fb6a26f0ce7d9bf5bde2e5d4eee3a14c311d93b9b78061e3694c7777"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a14fa009ece100cb685321c3c253c9f41c9ce18104babbba7eeeca18f6b28df"
    sha256 cellar: :any_skip_relocation, catalina:       "5f9fe1fcd1a100397fa12bb046f5e7384862c168956a4a0d415bc81c58bad68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "990e2d47e4f9b5b5cefcf2fb08f30f32906895f147d2d82100e46ba354df36c4"
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
