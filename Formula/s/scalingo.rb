class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.31.0.tar.gz"
  sha256 "791f575006ed6b5c7a48e377fdf0ef2ba9c51b73576dc05e30786d26d5d67969"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23bb6f615939c55da77e72dbaa2145f0d9d672c1a54783c5d4be1d7d1fb45e25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b014ab19882100381b63e6128947ce1cf7bda961ac65abd6a81fe0f68ddff29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7a80a169efaa9a09ece5da48e321c22d555249b1d0c769fdc6512a9b06f96a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "be4cc043cda5d13366efa724a2a8e2ea3987d71ee86740a6e2d978a681ed959a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e9b6723f50015cc6e26569a32043812a635709d039df0387d84d104d8818b9e"
    sha256 cellar: :any_skip_relocation, monterey:       "f745f27c455f599412cbb106e56233f1d7803f31736fa13d987e56521fe66000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed5918b1a996c3ea25f26e69abbdf9d60bb0d9f0abde78ffe2792965fb80245"
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
