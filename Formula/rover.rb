class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.3.tar.gz"
  sha256 "d91ba41397563ddaae02f93bae0602e9adc1686c681d1cef91742dac71b005f4"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16a37c0d63510ef36f80cb216371ecd094fc3948aab8d66ea833dc4639ea6ee2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11bde2c3312cabbe872ce7e185f1493c7bce3f2e8ea893fb8b0c2c2999fb8934"
    sha256 cellar: :any_skip_relocation, monterey:       "28fb7e2114531c60e22c61481d2405ee0ceb2f539f3816900968587002959aa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "25a520da945910a74029884e4da27239ce5070b55774b2c7f19cd66033a002e0"
    sha256 cellar: :any_skip_relocation, catalina:       "238c6b9c15444fbdd21f3632cfd807acd267b87dc4091d6659b347cbc619c417"
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
