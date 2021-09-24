class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.3.0.tar.gz"
  sha256 "1ba8ef546cfef89517a8ee9932aae683cab523d212ea8d3d4fe1359a15aa3be6"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9ebceb7ed5b175e5134c33e7ce4e83d1ebe9104ba2ddb87a951cebc8777317e"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cbb67e68e28c391110ed4ca72a5fab47dd003a91a802f4fee3fa7d497a1811b"
    sha256 cellar: :any_skip_relocation, catalina:      "609d8623c9646e2c9e791d51344751b1f5831326a164bd9b8ab4c892158305ba"
    sha256 cellar: :any_skip_relocation, mojave:        "29a1eb20e01b61fbfb3e96edea45406bb0b8d97aac4b50810580ab68dd44c99e"
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
