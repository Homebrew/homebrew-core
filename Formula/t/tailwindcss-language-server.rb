class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "489e5e10c8a4e21e0396080d076afa4aa3079ece39dd73b324f7d8d6adb3acef"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "891c68b9a704d7cfb06ba9f9312594cf7cb12137aa52639e41a783cb1b1f0fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "891c68b9a704d7cfb06ba9f9312594cf7cb12137aa52639e41a783cb1b1f0fe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "891c68b9a704d7cfb06ba9f9312594cf7cb12137aa52639e41a783cb1b1f0fe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "891c68b9a704d7cfb06ba9f9312594cf7cb12137aa52639e41a783cb1b1f0fe0"
    sha256 cellar: :any_skip_relocation, ventura:       "891c68b9a704d7cfb06ba9f9312594cf7cb12137aa52639e41a783cb1b1f0fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ebfd9e6a55f3e52a5c38676c0783d16e003791d4a79a5b2df2812978beaf54"
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
