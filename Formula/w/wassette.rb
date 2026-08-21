class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://microsoft.github.io/wassette/"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a2a95a418a3f9983adabee2ec9d3db427ac460f9f1ca6b93f0970242ac0cba94"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c50ea9d7540893f2af3c23bc8484a718a1d904e6c2eb2510567e2495a19c082a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a23d340109ad899b1d75c0f0e928789f2f041c458d92594731179eb7c8b1b195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423fd41d4b55299ddce37c0ab2d51fcc57a31ead6f7ae2944029a14ffb2406ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "758020a559b222bf84a04bc63bc093ffbdb5ad586fe45836b5e82347bcd1c59a"
    sha256 cellar: :any,                 arm64_linux:   "d3b7d99ccdbd7be11f913d3f5511f660c87034a47f7df0c82e3a40f0139a084e"
    sha256 cellar: :any,                 x86_64_linux:  "3679b440834198e49ba6d91e89ff3b1a39ca60e205d79a43d855af746c89f18b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wassette-mcp-server")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
