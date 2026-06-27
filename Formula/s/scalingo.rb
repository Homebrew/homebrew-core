class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.46.0.tar.gz"
  sha256 "b3933ca1539e7a12960e19667c63f3f725f13bb2d5eee3f05d5ffa634d301899"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e2914edad61c7e4566fc3bea84d53d0cf534ad70169cd4d1e5c3d52609f518e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e2914edad61c7e4566fc3bea84d53d0cf534ad70169cd4d1e5c3d52609f518e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e2914edad61c7e4566fc3bea84d53d0cf534ad70169cd4d1e5c3d52609f518e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14a8dd1e268dac5e689f3ae483b6332464a05d7831982019f0e6de3c9484689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cc123ae295a8a5435ecbc6dd3ff865239e60c5d150a8a2b682bd1be3d79da51"
    sha256 cellar: :any,                 x86_64_linux:  "26e27d334cb815651e2bda21abbdb9db6b4fa7c2e67a5605f8cb1748ba3b11c0"
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
