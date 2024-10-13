class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "a94a3515b9a0c18b38b38154ccea6a6ba75b9ecd6b5c968f133da4f3e336e96c"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7238fd929323c3ffd985ef08502ca9299d32d575f46f03504d812b61267d6568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3bf0944e38a713f89215781848e2114a97d4f8386a44555d08a1c4903ead366"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e730616dabf142202cc1c55f9129c6707fd12d978346c9f94d64a551e3edbb4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a3907fd2d05661fb4c06eaba1c4c373e88332306e7a2ceb6c13ffcc6b58651"
    sha256 cellar: :any_skip_relocation, sonoma:         "5684b6c9bb461e52fe4fb97e9df31130121798acd967566e0aab7330ec2fd4bd"
    sha256 cellar: :any_skip_relocation, ventura:        "a685ad6c9c1961a87941baa3c05c4e748dbacd96b293a5ad8cc2002b5818b2d5"
    sha256 cellar: :any_skip_relocation, monterey:       "cb42db02e1f9546e3c1f37a2808a1e24a2ab5eb41ade3cd5d98258fc16532b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fec84919e047f3dc24fe30bcc57669c879884419e7248d6a67381969dd6ded4"
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
