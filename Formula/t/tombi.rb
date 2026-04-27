class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.24.tar.gz"
  sha256 "265c0627b20f780a1a5404011493ca067754a2d458a1514e1b4c0d245e5d332e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67679adeff2fcd57a2881ece3c3a3b9d6a105a8fbb5f530c1574d557363f91a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3ebd8f56a7cb1f4724145d5b1138af8b5f2b6b7b5967b08212970f30855203b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1316392da3425374b24b2a350051896aaa199a05eecfafa9f4c986f53d5e34e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aa32676478dc9115972cf94ced91c966d9a2f46ed05ba68b913b42ede3b2bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22d5fce09c016e7c2bf5d315ebcbbe42b959bf4ca666c0d8ceabc162774f769f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937042d02435e38a4a211ec1b78fc01e693e2349906ce4cde64ad951c7e2f0ae"
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
