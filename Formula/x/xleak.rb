class Xleak < Formula
  desc "Terminal Excel viewer with an interactive TUI"
  homepage "https://github.com/bgreenwell/xleak"
  url "https://github.com/bgreenwell/xleak/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "79d3ff3ff2b6bf6c67ff03d8b2728b3e4678e4155c3b89abecd257283bb408cc"
  license "MIT"
  head "https://github.com/bgreenwell/xleak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a4345f10aa442799b997922a5b20cfca50fb113225bf664c71433085bf43009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a70a3933cb3c4dcd72610501c8a6daf30d712af1301ecbf7f4cff35420e51d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59bdb6e305d06f1dcce2b529e971187cb6b2a66db4ba6eca65d8a31ad46fd6c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9cd2ad6c3e8c3e48077c112bba3e0d8f53a7c3aa366e0e7adcbd05c4c14a706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af30ca4efbc3d65597495183954fb7f4224c47f3a2bcc1cacb46a2d1fd8c4c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "240c8ad7c7117ddfe275fab219521d6e7f63cab5d4d24c7522e620cbee6de25e"
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
