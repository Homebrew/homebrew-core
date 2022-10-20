class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.26.0.tar.gz"
  sha256 "34e56539e67c296e90ff10ceeaa070c280fbe4528bcfbe3394ba238f9acc1c99"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de68da00e654b184b425d95f805e8d56c7d11685219aa29394bcf2348c73bafd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1401a8b6a6e864c6924538ebf04bd5f660b6422e3128cb03a77b27d9e74f2d99"
    sha256 cellar: :any_skip_relocation, monterey:       "f98de494b3ebff663bbd838b19df1ef15cf3c2df03d98cd15b019a4e193e76d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "37da3df14322eced1066222b25dc827340d9190cd774814a2f989d63ee98b8f1"
    sha256 cellar: :any_skip_relocation, catalina:       "0e9ee0fb968a788313280e53bc2546d299de376a2edffdd23a1a8f52adce6f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1ef39b99b0efcb52d93a65ba2328be37920c5a6bdf2cd04f408f5151b7f5021"
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
