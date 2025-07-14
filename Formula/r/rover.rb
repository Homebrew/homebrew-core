class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "7d59913aecaf4aa13c6d513988c59ff2d76629c048344c3711a7a7a7780c8476"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b50a0cb339c40848ca2112d430c3a6680753b1603947032e082b163c106e6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa93c6719077378b0744d446f510553e47be736ff21e2a6b36b001a97fe15723"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37e1f715a33dced96ad4dbf23e032e0ff695839d8687efafb26f4f15b11c82da"
    sha256 cellar: :any_skip_relocation, sonoma:        "0057741636956e61154b9da32f4775d21aa1b6318d0cdc4bed0d1cc95cc7ba08"
    sha256 cellar: :any_skip_relocation, ventura:       "7a6ffcc9b67eb4d91262cb3796a0ac5fcc55e66f9e7cdee001d511b6674b2c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4892fba36104dc01534f9a63058ddc6ff2c1683658a7d95e2b500ec0c03fc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0790d731a6ba9b3de9fe27396ae7e4d553f408a96bd08fbc28a3d9d7c5abcc9"
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
