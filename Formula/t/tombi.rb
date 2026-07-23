class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "54b6cf69adf9a170258a3433b7d40580d7037411491b47784f17332dab3b59bd"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca17af4aeffa475a8fa83c6e47c1b9da10dd437705cb227ae006c92cac14656d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5dbcda7f0f0f944274f14453bed3ecf8c70093e027b7783801cba00b4c2c451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc0930041a5a02b7cd33d3acce1e5cd713e7d73b337b5676209ca3c1564fbf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c0f034aae50d3d1c0f1f4d34d772c0b652d7e0be81472a34692c7f0ca8fef3e"
    sha256 cellar: :any,                 arm64_linux:   "8b8de96c19f3cb7eed8d6bae10c3ec0d061ddf71c728eb24fe224d27cb757b4c"
    sha256 cellar: :any,                 x86_64_linux:  "00853162ed68580e862695d88319211ad11445d1f2f733a8f5d19daa09d3f446"
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
