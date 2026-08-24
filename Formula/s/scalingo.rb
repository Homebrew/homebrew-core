class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.48.0.tar.gz"
  sha256 "3b37068b861edb16d8943148975729357c208143b315488ad30c35e0ab0a0dcf"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd48bd7c71865f9501266b7d595e9fb89df7422ac6c6fb91e02c8b35301b80a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd48bd7c71865f9501266b7d595e9fb89df7422ac6c6fb91e02c8b35301b80a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd48bd7c71865f9501266b7d595e9fb89df7422ac6c6fb91e02c8b35301b80a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3d96a4b443427666517605a855d76bd7c9390d161dad06b28c92c4f7e8dea23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ebc88b662f89b42a6a34143f4f2d6913bbfa01ae9c1ea50264628893eff8f7a"
    sha256 cellar: :any,                 x86_64_linux:  "db3581eac102167bdae772c33b98623110b8b873b92cb291f407e4248491313b"
  end

  depends_on "go" => :build

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
