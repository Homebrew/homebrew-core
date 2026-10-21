class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.50.0.tar.gz"
  sha256 "81af63602eaff4d500a34f70ab54eaebf5ba119f24a910c5f3191745bb354982"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "721f7b3f24705a0cd5e399a0122177a1f80cf32c48cbe397e2fd48ab0acf4f32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "721f7b3f24705a0cd5e399a0122177a1f80cf32c48cbe397e2fd48ab0acf4f32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "721f7b3f24705a0cd5e399a0122177a1f80cf32c48cbe397e2fd48ab0acf4f32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "324f6f138ad5d074a660ad57ad2c745ef8826241c9750e5415c759dc280f9aa0"
    sha256 cellar: :any,                 x86_64_linux:      "0e89fef2bd02c1b2e9532571970b9225fb86ea8d9c940d3380bd4ac78fd5f8ed"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "scalingo/main.go"

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
