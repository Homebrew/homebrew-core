class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.32.0.tar.gz"
  sha256 "3db18d8cf159061e37bae2911d6f4a8e46d03c52bcd8c0f209d43c310fede67f"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6a0328741a218588b7694aadbce6c20d79feac5542cef811c99d71690ff9b5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0b830bed9937ed7544d8e948b0b652d6726fbc6cc8eaf7b52463921704e526d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67647f84aab8e2ab7910506a5b26f56f2185575564bb8f2723e38ec843bc4307"
    sha256 cellar: :any_skip_relocation, sonoma:         "62fa76449cdaaac3bed77135299f88f4f90864625a69d678423d9ba427faa755"
    sha256 cellar: :any_skip_relocation, ventura:        "9372a026dd968e5f323d7cdb3869398ec1f576032430942fc92d58397559ce19"
    sha256 cellar: :any_skip_relocation, monterey:       "283c1cbe6ad73b868470eece669224c761ca3d46dae55b9b37d7abf987f66d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9af24d64d46509b49673a3795537cdd38b94cb7f734937b9478ca388cb9b40f"
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
