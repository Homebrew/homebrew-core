class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.26.tar.gz"
  sha256 "a5b6115d6300b59227b6920c4a8801ed354e7d8e60c04c2434e81e5217a9b350"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff46bfa5fb3d8475d51640f590837e78ef88a4ecb70fd4abdc370614313bd23b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19d3d062fd2908486d1f9b6d416912f54c2bff349810af41907cd49429790989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d3d062fd2908486d1f9b6d416912f54c2bff349810af41907cd49429790989"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19d3d062fd2908486d1f9b6d416912f54c2bff349810af41907cd49429790989"
    sha256 cellar: :any_skip_relocation, sonoma:        "19d3d062fd2908486d1f9b6d416912f54c2bff349810af41907cd49429790989"
    sha256 cellar: :any_skip_relocation, ventura:       "19d3d062fd2908486d1f9b6d416912f54c2bff349810af41907cd49429790989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5138ce9a6456ad60769d0cd3b01e63633e0c27b4212cb735ceb80fa7c9c2617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5138ce9a6456ad60769d0cd3b01e63633e0c27b4212cb735ceb80fa7c9c2617"
  end

  depends_on "pnpm" => :build
  depends_on "node"

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

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
