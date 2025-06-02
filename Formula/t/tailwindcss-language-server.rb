class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.20.tar.gz"
  sha256 "05191814cb93831952971193bcee8ff281625bafc0f1655c353de83bbddfba6a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ab4ae8ed875d500c37ec5fd80148854fd763456f95ac6404579749b37c336a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ab4ae8ed875d500c37ec5fd80148854fd763456f95ac6404579749b37c336a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42ab4ae8ed875d500c37ec5fd80148854fd763456f95ac6404579749b37c336a"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ab4ae8ed875d500c37ec5fd80148854fd763456f95ac6404579749b37c336a"
    sha256 cellar: :any_skip_relocation, ventura:       "42ab4ae8ed875d500c37ec5fd80148854fd763456f95ac6404579749b37c336a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d7a33b3d93ffafd7ddc6223609f43d7b8fb49aa74a56ee1a54f38a1aa55f721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7a33b3d93ffafd7ddc6223609f43d7b8fb49aa74a56ee1a54f38a1aa55f721"
  end

  depends_on "pnpm@9" => :build
  depends_on "node"

  def install
    cd "packages/tailwindcss-language-server" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "run", "build"
      bin.install "bin/tailwindcss-language-server"
    end
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

    Open3.popen3(bin/"tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
