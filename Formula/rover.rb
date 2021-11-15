class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.0.tar.gz"
  sha256 "ab7de6aa9b221a29360c16ebb855b43d29cd79a6111c3b89e77f0d4f29a2002c"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f34dd0de4ca8ce710205a06ab8be4d43735030820342a5cc33c8b945041655e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab5e8a3c781e7ed16cf6ef376e0216d467d2fb4d10deebf079c5fed0fb7382aa"
    sha256 cellar: :any_skip_relocation, monterey:       "095ad3f4d36a2645ea2c30e9243e1c285c4a42b5119cf315d4a1e2ef2275ce71"
    sha256 cellar: :any_skip_relocation, big_sur:        "13493ea0d4b8581a0b168710dd87701fc4be74d06b620f7e28438b22ded3aca0"
    sha256 cellar: :any_skip_relocation, catalina:       "398b0d1a8986aef1dcd872dc81dce02e81cc31b32a0362747b560f9f1390f0e9"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
