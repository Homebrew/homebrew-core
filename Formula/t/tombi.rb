class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "9076a4e66fde36bed8805cd48972802adcf01406e58cc8c7b460d5e697de4896"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5ab42faed3ec77119bd7fca560ba0051221ff3bf2921c568695063b9f07893e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "580a5f83d8c31d516af0d800847d3c14ee9f9fba16b8437b2ee847fe8a115e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "734f7607527057b5e5631b22a8108136be1e9da13afc4297fda2f112beb312bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "54d98055cd63325ac51921f3dfa5469ba8c9b58382d29fa4775832fcf1d0608a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3fb378ad3a238039edb02bebe743cde2a072e7a7e03a4269483fd9c0628b575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f9131663e33abdd20eb973cd2a8ccec6268ce97a8e8afe62dd95c7670f96e2"
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
