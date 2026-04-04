class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "a41e5fe2bd0dd25ea55b1d0bd2a478611427198225f8544739c5c121d14717e8"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e246beb1a3695436d7cb6fe0263a0d7a74182630b6df0b14525effa8190cc92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84ff1fcf51ccfd1b8d18ca13a06d20ee46143f18915dd0cc2746ca52d568d667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e94250aa4c1ab3fdd6bcd46f8f4c830f1076540ed3addb0992fc770fb8b8442"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc26dbed66968c364ef8a55cbcbdbb6ca2780fba6b27307ca0972bfb517e80a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a48f3d4ddec599f2f6372176ac2c0384d9520723b3224f182cc7050653e9b36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b86f64d3410919892091faada0da90246ececfb785e7a41ef7f74eb054d72a4"
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
