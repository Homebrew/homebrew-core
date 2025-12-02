class Xleak < Formula
  desc "Terminal Excel viewer with an interactive TUI"
  homepage "https://github.com/bgreenwell/xleak"
  url "https://github.com/bgreenwell/xleak/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f5d95817d3729ed47f45afa499e7de7209cb41a5bc44fc1a9d121b14d9838191"
  license "MIT"
  head "https://github.com/bgreenwell/xleak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "098c3d52ad1df85f462d4d47762da98f786c8e80718a49522421a9d0535c9edd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ee2f3a9ab68024db618d712051a6e31f5efe12e05ad8f1d3da05b08b7f858ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6ae0b90ab3c11cca515d62da5c9673fd9c75bb3c1f9817b8c540a2061846c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "a410e53c5523c979c993a3d476160c96cdd8578fb2c022cf9da3ec793f8036ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "762f06c25fea18d688b8a351bcaf5aa6ac52957a8197244066dcd599ce67dc7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c13f804048bd868354d9af5bc5f6737abe83bb8415245ed63da535e03fecd9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xleak --version")

    resource "testfile" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2025.11.16/test.xlsx"
      sha256 "1231165a2dcf688ba902579f0aafc63fc1481886c2ec7c2aa0b537d9cfd30676"
    end

    testpath.install resource("testfile")
    output = shell_output("#{bin}/xleak #{testpath}/test.xlsx")
    assert_match "Total: 5 rows × 2 columns", output
  end
end
