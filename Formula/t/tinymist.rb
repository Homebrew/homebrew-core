class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.26.tar.gz"
  sha256 "917231b4ee02c43f4794b23f834e8b03d14b7d9bf9c615905084c907bedcbd71"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d70e2315f9aa6904f82d3df6af60026eb9a757f3d9b5bccc20479859dc7edcfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4c5715d13e9b6662889e248f24833b8ed2b1982e8b14353754fc0dd13bb5db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc926d584b0c3b0ac711224804a916a195501783afa18707ad7a27536412241b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a29ef4282e45fbe186c2fff4c41811f5e20b52fcc21a557070bfd3be01b56a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1d819e7df7c4a527d6ca80862c5e9dd38126407609980f37cd5255dd6704b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "795f4dbbb2621b4249561240dfe97c4bd09ed0e547efc543ec33cbd279a62e4c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
  end

  test do
    system bin/"tinymist", "probe"

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

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = IO.popen([bin/"tinymist", "lsp"], "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
