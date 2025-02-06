class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "05efc986955321d19f25e3b2fed6ba75c7f1ad3e71a641b1d474b2ac750bf8ef"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2170d616153d997c2aa456722bbe71baed71f96ffeff6cf6b7f1e880f257879f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2170d616153d997c2aa456722bbe71baed71f96ffeff6cf6b7f1e880f257879f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2170d616153d997c2aa456722bbe71baed71f96ffeff6cf6b7f1e880f257879f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2170d616153d997c2aa456722bbe71baed71f96ffeff6cf6b7f1e880f257879f"
    sha256 cellar: :any_skip_relocation, ventura:       "2170d616153d997c2aa456722bbe71baed71f96ffeff6cf6b7f1e880f257879f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "987a2437d036fff3233ab268e633bb6d6c70f20dfe0df49413f1797f0634e2a1"
  end

  depends_on "pnpm" => :build
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
