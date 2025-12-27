class Velocity < Formula
  desc "CLI for the Velocity Go web framework"
  homepage "https://github.com/velocitykode/velocity-cli"
  url "https://github.com/velocitykode/velocity-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6809b80e1b561e036b78f73d003bac00105cc015b46cfc3234a496a928bc48c5"
  license "MIT"
  head "https://github.com/velocitykode/velocity-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"velocity"
  end

  test do
    assert_match "VELOCITY CLI", shell_output("#{bin}/velocity version")
  end
end
