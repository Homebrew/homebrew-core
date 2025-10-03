class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "fc6e87d7f5a579a327e6e14da68e498f74b7f0f875aa78f3ee58881fcf756a19"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6d0b49904c13ed93ed6df823eca464c95379746214d44e1682d6af022c01d2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2c0dc0f8d75f29cc3f40a8d42e5fa16e8d406019768551b71e092f0a88d20a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2579538362b344cbf2b88640fec38dd5310497115cd8a29a4a66503dcde27443"
    sha256 cellar: :any_skip_relocation, sonoma:        "f63422cacf1b5b58e49284be4061b5f794bc6979e26a0bf517a4047c2a799941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28d3aab9450545a5ad2bc25deb17b91e5c1cbcee27a475ba545cd442232fb9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f8c1e6d2fb5122d9bdc2bb5858c6d1e18f34fb2399e3854d8ca9d50ad0fcdd"
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
