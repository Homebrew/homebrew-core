class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "b2ecdbb0b686fe36624979f4dbf030c79409c6efd508fa36125ad192c10e1298"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2b04f37c7937cb3a0aca44e6ef9b1476b9bb58ccd0182a804cfa71d62c02200"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12d71ffe353d87586923bb39d94bba87dd993c4c1689d681132dcbc732bc0fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57d8a2c0ef341737f1c916e3887aa1b7d03a495e176e704b4b77f2354638d2ce"
    sha256 cellar: :any,                 arm64_linux:       "78c7b366defc3f4f5834648a9bf6ae3d87d134fbd787caab57d49445e60202c3"
    sha256 cellar: :any,                 x86_64_linux:      "aee0af2d056fb462024fff4ea0c16bc2050fc00252a7e5d7a2f8dcde14a511bf"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
