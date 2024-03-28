class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "0b6a968515e2684d64afe8715f74a7d351596a87001b9533f697ba187474b0cf"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bbd0afcd51854365482dbea8d0313809b96e7ac43bee3d084cfa97741bb37b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7cd75c54ab42309f84617ec9c2e5b60d4b058dcab8b6f818f65c5f34b129c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80e97028be4909ba7129e471bbc032496b4d3073a12b2e6eec400ee38298b099"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd9830df2ef58996d235089b248349f25c355477ca79deb799738c36f751564e"
    sha256 cellar: :any_skip_relocation, ventura:        "46f1e563867350d5fb3f6edda245bd7e3b6d7b2a0dc6deb952fd74b79705c103"
    sha256 cellar: :any_skip_relocation, monterey:       "6a511c7f5123d9848514cd0baa1a1065488ad6b4daaab9bc3bf3bcbb14a670c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5117cbeee0df343f69014e8bfc465a54bbbbab9740074aed988950702e9efca2"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
