class Sfst < Formula
  desc "Toolbox for morphological analysers and other FST-based tools"
  homepage "https://www.cis.uni-muenchen.de/~schmid/tools/SFST/"
  url "https://www.cis.uni-muenchen.de/~schmid/tools/SFST/data/SFST-1.5.1.zip"
  sha256 "155a66ffe45328269bbb2e6765c060a1c656d429f608d96a5e3ce6911ede12ae"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(%r{href=.*?data/SFST[._-]v?(\d+(?:\.\d+)+[a-z]*)\.[tz]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "828d946db1ca69de2021906c808d18ed41b2e8c384446a0c9b39befcc42c0a7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a99c2a6f971ef8282e2196127b4a5b13415caa66df89cf5d5b2ff586a7bf2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f55745637948632398775bb967e65e61faf24c7d25edaefd72c1cdb3694358a3"
    sha256 cellar: :any,                 arm64_linux:       "552fcbc9c57add1cfdce7141e78f0ffb2440f2a1746ca5690637a3eb267152e3"
    sha256 cellar: :any,                 x86_64_linux:      "74c16885b11c5961fe0c91ab7e314a1345fd9eea050100d95ac993f122ff9151"
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
    system bin/"fst-compiler", "foo.fst", "foo.a"
    assert_path_exists testpath/"foo.a", "Foo.a should exist but does not!"

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
