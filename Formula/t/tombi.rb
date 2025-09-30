class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.18.tar.gz"
  sha256 "3ee7b392f4264fd928384f6f22f10cb03f19edefc1b336194b242941d9641deb"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6ac49918a888aed49b4f5e147052ce8f58d2ce39f486f745dc7d2b82c9bf62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ed1840719abfcebdbce4f250c07444eeede76d7d87c4a0871b6242f3742f90d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3626e60f99c9ae8443e3eae6a2a7ee3a44433881a2f5baeaf8c2047d0040ff44"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f74438f49238ba0eda2704c4772a77ba283b219c612d7086b9094ce9dfd3da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d335d30253556763a8eb3a70300f4c084ed240cdbbc76d9bad2d3b0028a6d54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c3e0817f00dc29bb9d5cf8576191f9658092ecd4f50311d305572e575347975"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
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
