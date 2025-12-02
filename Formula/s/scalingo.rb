class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.40.0.tar.gz"
  sha256 "19daf2484601ad2049592c467440a107e6ac6eb7ce1e3599d095455c795bfe1c"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f83f9383a8a16d227934e70082857beaa30a95f91b065b2d76dbcbd93cc27d01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f83f9383a8a16d227934e70082857beaa30a95f91b065b2d76dbcbd93cc27d01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f83f9383a8a16d227934e70082857beaa30a95f91b065b2d76dbcbd93cc27d01"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f15ad77581726dad0eb88360cf25c8157128817237e846180279f65e94ff93f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fee294df1110702d950c640f4d031b456167c7418905e143867ca8e210142fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e41b2ba8b4b37ba56784b7be58d9798c6f721a204c4c7c3b7bb7ec84b5118fe"
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
