class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.29.1.tar.gz"
  sha256 "70cf9399434c9f8a46bd0fd46fee345e1bb83b8f7691d4288e0e29ccf9422ec3"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f703bd10dc1738365538b17c124903dbb603f87ca1da92bae5bbc85858b4d043"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f703bd10dc1738365538b17c124903dbb603f87ca1da92bae5bbc85858b4d043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f703bd10dc1738365538b17c124903dbb603f87ca1da92bae5bbc85858b4d043"
    sha256 cellar: :any_skip_relocation, ventura:        "fff22d294129fcb0070e0445948d11f1c5f02eb90317b5f3bbbd51d88bccec92"
    sha256 cellar: :any_skip_relocation, monterey:       "fff22d294129fcb0070e0445948d11f1c5f02eb90317b5f3bbbd51d88bccec92"
    sha256 cellar: :any_skip_relocation, big_sur:        "fff22d294129fcb0070e0445948d11f1c5f02eb90317b5f3bbbd51d88bccec92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f488d2e378d02a685efbf6402e83997e127f784eae4facdfa224ea64f56a00"
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
