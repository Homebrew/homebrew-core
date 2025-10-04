class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.27.tar.gz"
  sha256 "0c5bae8ae5ef74f973b08fba3fadbbd767113ec7b41066418556654b2bd54907"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff7399a1246f98cf6b2b16cc3dcfb1424ffbcc3218bb2461fb740e84013a274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dff7399a1246f98cf6b2b16cc3dcfb1424ffbcc3218bb2461fb740e84013a274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dff7399a1246f98cf6b2b16cc3dcfb1424ffbcc3218bb2461fb740e84013a274"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff7399a1246f98cf6b2b16cc3dcfb1424ffbcc3218bb2461fb740e84013a274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd0d394a7fe63caa53995196f53ad79516ff81c200d67618e8c6e9bd1d533720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0d394a7fe63caa53995196f53ad79516ff81c200d67618e8c6e9bd1d533720"
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
