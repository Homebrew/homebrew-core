class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "accf6257f030e109d8626d2acf2885d2512d1a8918f88ea4e392712d879768c6"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6cd5113df7b5fa741b579fabe670082b3db726d409a2b6e6a040725e645328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f695541475d3624eaf460cb919b6b7943667d06d344e60248638348a7668fac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bdf99703863f085054061e22226eaf24e8477ca03033196f6639b986224fe59"
    sha256 cellar: :any_skip_relocation, sonoma:        "940df1db811a7dcdf0497462978aad568c5e24aa3dd3d5fef2a71c792b4491b1"
    sha256 cellar: :any_skip_relocation, ventura:       "084045bb70b4dc4abd88f50cad1135a637379b37a04ec6eb1d6d813f79b08f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ce9fd008f5ffe0080b6677b24c8fbd5b3e324564294e653b19cc1fc2a896e6"
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
