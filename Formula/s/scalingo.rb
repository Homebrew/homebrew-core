class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.35.1.tar.gz"
  sha256 "be545b75876bf1d72de9f1ffc97654df20bfb7e6912f670e8cea1e5b65f5e8c7"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "281703a70557f188cbf47cd8a4f6819d24d4f6070ec2b5887c91d79e828f53a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "281703a70557f188cbf47cd8a4f6819d24d4f6070ec2b5887c91d79e828f53a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "281703a70557f188cbf47cd8a4f6819d24d4f6070ec2b5887c91d79e828f53a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "340c8440702c3622457692e691e951ad369000d0e4e04a190ad364800f578c71"
    sha256 cellar: :any_skip_relocation, ventura:       "340c8440702c3622457692e691e951ad369000d0e4e04a190ad364800f578c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b708867a34cf3c95f13c86fd562eea03046ac3acb4299def19e14eb7da7b71a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
