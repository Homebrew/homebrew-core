class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.24.tar.gz"
  sha256 "5658120da99a341a225fc4d19936095aca4a216f44abeb54ddea04ad2b36b37e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9b11fafcaf59584a0cd3149d03efb5b62be792d8120b4c90bbe1ac47b33e846"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4ba237ec0cd8a3144e802421addc5b1a623256a7f1ea7dd6cdaf83a374b0a43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2061d63de70d1efef640eeef03b4516145e5c73b2a57ac7f4f07cf0bc721a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "3885072364b3ff0073a952eb54bc777177b624e61f497a480443bf2d13dda896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b22f60da789fc1bbe533cf62160b795579c5047a6f7a1d66848a1155f7bcd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dabe0b37f65094c038ee5b7d4cdc7df3793d7d1cfdc3449a2a9ff482284a58f"
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
