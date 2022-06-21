class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.7.0.tar.gz"
  sha256 "e8e271a084123feffac8c0a566402c0323cb7e1ea37f8c740b9fb883f23cad80"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e4635253dc0eaf1311a544234136a5276f28eb2fd15aceac15ec09e09b38aa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "378c34c904ddcc0dd433e2a1987b847b0df7b8171611b75e3849a76fe0aa60b5"
    sha256 cellar: :any_skip_relocation, monterey:       "ce829703de0145e4ec923df68684b6a5775d061fa8fbe1c3599c3dc7122f48bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7ec495c595db5d4a7f4759c4e3a64985ed3b977d7192c55d05b0180b25f53b7"
    sha256 cellar: :any_skip_relocation, catalina:       "e59658b6fccd004d34959fb52343efeac830cdb2b34aec8f7c336fba49725479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05e7dcd2483815d2e8befcc2253c26b45101d12ac9eee4c5f6fcbd67f650a8b"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
