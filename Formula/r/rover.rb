class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "d3b27add53fc0d8eedd89ba3a6a0d0dbb1833d268f79c0a81f755c44e7db8735"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c6692b19fad4a7d74a8ae9ce5fff10160a78e0af013665af7f7a8c0f57000a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79797beaf07c8617255422857c9c7a087c418b8891d559605c4fbd0a65d1cca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a71ef373f98071f9b120a3038bb7ddaca90173e6d065e1873fe5cb1e1625032"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3bd3f2682e500ab90900fe69dc4dadf96f3ebe945f936e9a096116630bae794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d4c49412701e7f84557dc2aad3cf463debcce42b42ffadbd2ccbbc24aa86001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4991b995bf2b0c01ae9ad5b633a09a53e86b4649a6ccebbb2db71c8f5f4fb780"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rover", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
