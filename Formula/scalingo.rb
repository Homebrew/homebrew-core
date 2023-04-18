class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.28.2.tar.gz"
  sha256 "b147258998a9c632fbaf89db5ddb1fe79ab1dc3ad4dfa2df4b3829223e1ca519"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a194d69f1d90c0f56c70f66d6c9cef72b3c9c2693e5b2d6db7c95a6827d945f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba82a3b9d0a7ca58a50186ad230167b7786df8c13f7ac26c5c75d8a9ec4d4615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f092b5493665ff06aa688c1f9a69e315940d6db096ceff1dcf9bcae84f190754"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd62898585a74c77e7f92c89037d407e7784b8b4e2360eb3bb343bfe5fa583c"
    sha256 cellar: :any_skip_relocation, monterey:       "91b2788aa1d48af6e31abbf86c1a296f3fe84c12830e32a0b58357f66816ad61"
    sha256 cellar: :any_skip_relocation, big_sur:        "1acd9e1b21b8463af10d6535c10bfeb6d38e0585ecb193599447851d4df38b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f101af8e23bd06893957dce9c6b6fa4cb6a233db14cee1e342111d02eed693c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
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
