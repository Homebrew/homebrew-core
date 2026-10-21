class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "cef8d530f23af3b239fe051a31edf6aef3f0a22f40f755f10428ee19f3e10673"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "387b8d242092d848a79804438f1e411359787785d287e03a16dcbbbb03be0d20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96b902ac256cef54a720a097a3f24c9c9eeb62d25c2f5b77728c1599ccb8b49a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10a5339f1655bde060388ee95cd38e36faa0c23dceb831221d2463a35d79c2f7"
    sha256 cellar: :any,                 arm64_linux:       "2b45fcbcf3d69f4ba03b0404d62a2f0d4eae50f4e0979fbd252107e541c588b6"
    sha256 cellar: :any,                 x86_64_linux:      "f481046af7334b55849f26eb6a7151b67e86c91111eee4221f1fafe068be828b"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
