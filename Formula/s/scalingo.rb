class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.42.0.tar.gz"
  sha256 "190d3dde9b308213b8f2c3d83c6a52175b728c0238a1059677765153019f12e1"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31bf2ee459a83764a84b1447c9ac118a9f0d42d195a9007af08adb04fbc6b260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31bf2ee459a83764a84b1447c9ac118a9f0d42d195a9007af08adb04fbc6b260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31bf2ee459a83764a84b1447c9ac118a9f0d42d195a9007af08adb04fbc6b260"
    sha256 cellar: :any_skip_relocation, sonoma:        "15f3139faf86b1cad4a8efdfb2c0b08bbb96321ab60a7ec993b6be454310ac8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe717398e54ad8c4a2665d823368d5df1ee03cb6723e4f341ed72e60e3c7c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf0e6a28a2c1b1a03a9500a7f0808fb42a0d7bbe06c131e215b87bae51acd7f"
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
