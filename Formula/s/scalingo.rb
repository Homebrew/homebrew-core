class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.47.0.tar.gz"
  sha256 "2931dc044dda655ab85dae572e5f01fb13942392bdea379231306c29d97c3efd"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "864517b5b5ca695e43b72a9cda359c0557929fe42506b68c39b5000885c6c4b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "864517b5b5ca695e43b72a9cda359c0557929fe42506b68c39b5000885c6c4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "864517b5b5ca695e43b72a9cda359c0557929fe42506b68c39b5000885c6c4b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee4a2df04d1deb117234a08d97fc1d2d81a3b59ab2abccede645400bfa8b36a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e58c97fcbd18b1a3b26619950097d138328cfedcb11062dedaa38afdc8cc19b1"
    sha256 cellar: :any,                 x86_64_linux:  "376dd81fb786c62356c3fb12bc22217b8dc4a8e697932500c8057e0974864e0a"
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
