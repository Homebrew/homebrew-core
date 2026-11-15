class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.14.4.tar.gz"
  sha256 "ea870ebff82a994271cba5d044e664095c9c8810178864e6938eb7aaf643b495"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df75c95e31fbc290501640f06e2d464dbd5b89cb393b2fc745e0be60023ebe1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2ddab5db938acd5b2ec33e4e6c57b0798dca3ce13c15c04ece36a7a6c321fff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c64e9f6b8b0763c4d21d87c889c7131c37b6e114b00e5d207f0ef754d53787a"
    sha256 cellar: :any,                 arm64_linux:       "edee2221e81ad033f8c67f571e0fce9a1c483af11004460a39336cc8420e70f8"
    sha256 cellar: :any,                 x86_64_linux:      "4f28e5ae32d13e4fca9dacb3705f10beb1eb71f40fed7590b3e2bfa22e93d245"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"srgn", shell_parameter_format: "--completions=")
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' -- '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' -- '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
