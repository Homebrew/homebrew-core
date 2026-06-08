class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "e8416d989a8c672ed57520aa5f1f50b81094f4de31c4043a47da46a8fc5acfda"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfe4c356bf3a30a77e864c171fac1313f6f1ecafc449c1993c78102171c13e91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f9d1188f5f80757cff14c50d980dbf9be62f2c5fcef3f1ba7322bc164222874"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d3896d3a956a22c368330c6fa3f2840fdf1079ad021c82e02294efd162a0c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0381179081173195317941f65809b539bb2a6152344e26fe4b716e862270801c"
    sha256 cellar: :any,                 arm64_linux:   "7eddf1bca4849881e868ab7456009c1c5859921807b3e2285ef9d446e015268e"
    sha256 cellar: :any,                 x86_64_linux:  "640d19adead7240d9761167ba6158429007785168e7a3811785e8e47daf6d944"
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
