class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.23.0.tar.gz"
  sha256 "382e0272296595f0327146cb37c5b991c5e3387e26d0f0a4a01b9ab6df76befe"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "897840c13000d92579aa1066443ac0d7ec9df705b604b36a6b3b4eb0330c26af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4631b61b8903c96cc9fcf58406860b1a7ed17b62d45002704beabadd6b8f97aa"
    sha256 cellar: :any_skip_relocation, monterey:       "6ea9eb9933907793e3b79a9c35f8e9bfbee9f242e52f0ef9995e7dc26d871027"
    sha256 cellar: :any_skip_relocation, big_sur:        "f144e90ba794319911b2c5cd8cbeed709c9cd0e08a168806498b58458abf9435"
    sha256 cellar: :any_skip_relocation, catalina:       "328deeec81ca75c0bb7a511bb97145b95ec41081ea2fd9043475b7ac0df554a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85bf751d4b347efac2d4dce7845fac6c5bcbbaee166c7be1fc6d2d244e6a76e5"
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
