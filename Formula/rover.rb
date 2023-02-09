class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "89e4596aef6e28ed3c3cbaba581566a9fe8147d381d291a69a3fe01379ef8c85"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7395e1aeafb60bb4a05717edfed6ca6796073b18bc957c9730d1a144d4406fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dc9154500ef664d89bbe014248545eb5260a32a7da7fe67d347d4c45f6123ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3fb8f3e6d7ab12351f707b51ea66830606987fa2532ca88f0da19cdc047de30"
    sha256 cellar: :any_skip_relocation, ventura:        "a81b01b266178640ec76c6e3846f70d9783a68529692cc21b993bf720326f4f0"
    sha256 cellar: :any_skip_relocation, monterey:       "f618a5effd87046fbfd3f6286bea3dc262de1c61117766e69d97f8e2c78fa0b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "11b4d34fa30e11ee02d0898331299979f524d8739f1a629d33e46cddfc652aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0793f5cd787a157b817b395172eebe2c7a9dd41432617bb4684ce03849c621cf"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

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
