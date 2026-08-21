class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b979d375913be969c6230412e3883fb36c2ecad0a021176563cdfeef8fcb23fe"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ed841b5b35cfb6e9541edbf46b5f88bac3ac4d0d79f18731a4e8dda5db7a04d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5312b6a7648894d02bc405f844231ab4c701b6a24e5420c01ecfbb628ee41518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c9e78b559aa1bcbc749e5c79ea88a7b675a33ac6ccd7bc0dcc12d6287298e00"
    sha256 cellar: :any_skip_relocation, sonoma:        "1be9f08b471d4af89be6260779b2d0c1a919a8bbf45fa77335bd99f8eda951b5"
    sha256 cellar: :any,                 arm64_linux:   "e9655821cbf401807fd28784613a2eef7e9f60cd650314b8aaa1edec0bc03421"
    sha256 cellar: :any,                 x86_64_linux:  "8f2788e2887cd0d698c7bb7def9d56979d9797ca53cd465389f8068e453e98e3"
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
