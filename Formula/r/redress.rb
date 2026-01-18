class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.52.tar.gz"
  sha256 "73ac5a3c509c1521ebdd8bf532bcd51497822efc9b49c7965c07cbb1b9b17d90"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a03ccb5c8fee75def1ea57fe1b24d475f837273c2edd098dbc976aacfaf358d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bbfc71fb6046d9c296784b4ade21ebc22fe8a3ad5df21a2d068087ca7f19590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cdce46d9548ef3c7770c7a82dda5230abe0fc429fd04f3473b3a9edf1160c1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "24d7459583e61be74f90c721997acabf1f04cdfe443c56c299cdf77c75e59fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e87bd69fb96345d41f01c1c7149a2213e3fa66073ad1b153436c7369923bc5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7859aeee7f377ab884f1b854d33c48d2e5a479f224268516b3d391cb00ceef37"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end
