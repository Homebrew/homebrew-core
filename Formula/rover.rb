class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.1.8.tar.gz"
  sha256 "3a559cef43acf49b5de84fe05d6a5fe12ec589a203ce944ebacd47530e0eff81"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

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
