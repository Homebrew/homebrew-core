class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.16.tar.gz"
  sha256 "f9c8f33ac4208f7f7d3a56f3005645cb5959fd8bceca56488c7016a0880ebe1c"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5ae315923a00214aa33b536f46e0f7a7dd0299928c1df2b3aeaf25dbf1b324e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14962661c5e1303769775eb737a8b75f7caab9073327e67881302c1a8ca32931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "638aec58d38727c79265dd35fc806c9ada01625495430383dc4dfc50b38c125a"
    sha256 cellar: :any_skip_relocation, sonoma:        "47224320f7b30bcb8611c969d06393a69f7e6bc4b33c89559b7f931645b02dda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50032f40e6bd88882d1df4a529512b79c6b8c6822dd8d1304e56ca643c70a42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f990a50cc931dc86f527d241517b6837281feaf9ef4470398add5fb44efab9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
    generate_completions_from_executable(bin/"tinymist", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
