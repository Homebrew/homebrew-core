class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.31.0.tar.gz"
  sha256 "9f6c8b1304a338062e7254e85855d84a94f09c353e9d6b2ebb38dc147ee44a11"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83370004d23db1dc0b140e1f3986a7349ceb0e4e9098a6f6afd181d09273b88e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "656a609c14843d6d7f8bef14fcb8e3abd92de5c3490bf8621ce75301c201023f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54131a8da13f52ae23a85577e0bb9dec1c0d786b567cc5a201d80424e54e2673"
    sha256 cellar: :any_skip_relocation, sonoma:         "0900b301880372fcc34c5fd28eaacdab8ceb7c1b4e0446288bd008028cbcd681"
    sha256 cellar: :any_skip_relocation, ventura:        "7af7df798b114114671216c0a3aca16368519b933a112b13f6170a60c111a5d9"
    sha256 cellar: :any_skip_relocation, monterey:       "74cf57da07e260f7e45df491df94b8de1ad60cbacb8d5efa2e5ac88444406771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677e3b5aefb3d8597e9a4f51b3ab402ed5c185c944223af9a120dcf31c2ec558"
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
