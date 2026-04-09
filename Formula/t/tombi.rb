class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.16.tar.gz"
  sha256 "6fa87cb82c0a5c6efcd77104f38d58649bd3d3c03df21cbf32c0f0976c541ee5"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b67e8df9c94da2f9fface8792aebbfae6c521614929144f8550d9d8350feaac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d967985e4685d957482cccd811f344e9d4646999830041c7939a3015b535b715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb60474f92819dab2fc34206bd0a1c577747ca24bf570a7243ebea080df3d3a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5361013617055161c81b5b726d477be0a80c8753985b743abb22834b7645c5fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12debe277217e144b774c8a904fcd392600f54467aca5d699b302afa51aa047d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f40ce14c91032f8cb72b233d54a82ce5ebe1002986592e704df10189e5bbc5fb"
  end

  depends_on "rust" => :build

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
