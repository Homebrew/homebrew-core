class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.34.0.tar.gz"
  sha256 "76120c14d13065df48ddfb628aab0b59d9f32be43516607c1ecf3d258bc692f9"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ccfca4d80c75ff9ae1d09c5ccd1282ed7b7d085887bc20fef18534f65c12b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ccfca4d80c75ff9ae1d09c5ccd1282ed7b7d085887bc20fef18534f65c12b84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ccfca4d80c75ff9ae1d09c5ccd1282ed7b7d085887bc20fef18534f65c12b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "512bf0121d3fb2c40ed08117c635a5aa221323bbdb90bdca786e29fc2774ba35"
    sha256 cellar: :any_skip_relocation, ventura:       "512bf0121d3fb2c40ed08117c635a5aa221323bbdb90bdca786e29fc2774ba35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3638077a67aaeaa879eca09ed286a8e64ab5cc2f5fdf7b5aa82360d3486834b"
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
