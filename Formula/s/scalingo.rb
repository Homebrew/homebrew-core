class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.30.0.tar.gz"
  sha256 "71c1ddaa2c5b58236d5e3b8cac30363f3c4b7b77c5150eca80054af1f0765892"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65c9671349686fbbdd95833f87d3221f3bd25b917b65c604aee30dc96543b86e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4bea76906c126b927d70da9e9baa2d913b9722d61deb389224fb291c85cc5a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bef4c9816ce2c73a898ea37fa239ba6dc92fe218eaf6e1da9682af2abee2186"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fe63aa0f2088ff4df97104e4dc3fd1e9ea4214f6e1748e5558e3fb7d64b7bac"
    sha256 cellar: :any_skip_relocation, ventura:        "2d8b3fba465c8b11db3fb29006b854df9739e927d3563b867bb99b7ea0499a4b"
    sha256 cellar: :any_skip_relocation, monterey:       "c80d7c19536f1f0619fe34fed5be903eae7a630cd3616a7c75a9e3a0048f6a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc6e61ecf9a2d7ba5f160f42e8a50644fe8619334baa41a9b4a8ea98856de887"
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
