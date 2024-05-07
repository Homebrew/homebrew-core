class Verticalize < Formula
  desc "Simple tool to verticalize text delimited files"
  homepage "https://github.com/lindenb/verticalize"
  url "https://github.com/lindenb/verticalize/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e8aeb3e1ce0e836aa5e47ccfe75578eb96240e5d181a78396b375bc9916d331a"
  license "MIT"
  head "https://github.com/lindenb/verticalize.git", branch: "master"

  def install
    system "make"
    bin.install "verticalize"
  end

  test do
    assert_equal "\n>>> 2\n$1\tone\t1\n$2\ttwo\t2\n<<< 2\n",
                 shell_output("echo 'one\ttwo\n1\t2' | #{bin}/verticalize")
  end
end
