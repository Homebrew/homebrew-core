class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.29.tar.gz"
  sha256 "50bd5f0fa99b055871165f950db704ce20b12291476d70ea957f96da132680ab"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1851593616dfc24f7d20fad69d25478fe3628dd23a5a046aa0d219300265998"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1851593616dfc24f7d20fad69d25478fe3628dd23a5a046aa0d219300265998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1851593616dfc24f7d20fad69d25478fe3628dd23a5a046aa0d219300265998"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1851593616dfc24f7d20fad69d25478fe3628dd23a5a046aa0d219300265998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feaa7ab8e63b03b7d9294fde0183f0e297f0bdb7039e862c245635a7f197dd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feaa7ab8e63b03b7d9294fde0183f0e297f0bdb7039e862c245635a7f197dd16"
  end

  depends_on "pnpm" => :build
  depends_on "node"

  # lockfile update
  patch do
    url "https://github.com/tailwindlabs/tailwindcss-intellisense/commit/6f19018d336ae1b72e124569dd3ee4f328df2fb6.patch?full_index=1"
    sha256 "ea45bfe06cd0f89c790d465510408dd1adf4ce8364ed24d56c977b81c22bc635"
  end

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
