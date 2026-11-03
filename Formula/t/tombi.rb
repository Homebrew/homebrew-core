class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "2f547f4adb35b85b01e1a64fea911cdae5e4c3eec4903fa04cb8f05eaf473851"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ccda330679bf68b8d47bf4000ccde3b46a8fba6f89174fa5aeb4856c6dd9d28"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "165f810665f40e1a32956d7b5483be618c2106687a9c1f254ed765d2ea38f4d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a612428049b4e6bb5dd05eea216ce0cf2212e6b3fd6dd98045f0955b9a51b19"
    sha256 cellar: :any,                 arm64_linux:       "45775d24ec2b5d73b0515943184743f32cb88322321f2dfdf73cf2105a6fe71d"
    sha256 cellar: :any,                 x86_64_linux:      "f0c143c940ea303f8d68736d0a72b5db7d65d22585773e8d6d149a2f2b554505"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
