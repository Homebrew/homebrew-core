class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.26.1.tar.gz"
  sha256 "cbd20f7eeb1cf10c855cc3ec52e419cbae3041677a3a703f09d08679dfa41da7"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef29a3c472091c0ae87334f797ee7717e5af82bb94e0d3aab118fd91e3ccbe83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc1d905b97896fadc15c35fd9b1919e870340447ccdba670123e70f1584d8d22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d72435f55a6ed71af99dde9e6616984976316573649aca5eb4fa3486f567f258"
    sha256 cellar: :any_skip_relocation, monterey:       "7b0b27bc708f76ff706f1e42b46b12938bb14ef3ef63694eaea209b5178f3214"
    sha256 cellar: :any_skip_relocation, big_sur:        "16b83553c886a92f9b690c88e52a60cb2086baa21640421d417136bda7c3ded8"
    sha256 cellar: :any_skip_relocation, catalina:       "ad58eee161d0eb5f9ab3e41084055b684e4213bf1b37be1470bfb39739c63bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7cbceabf36784a4e0bb136519159d9ae1b2f14e6392c90d49ffd89b9d52010c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
