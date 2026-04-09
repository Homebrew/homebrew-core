class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "c8cb9d6c2d04b4ad3b69c1b7373e12990ddf5147e75b808ebd40fbc5d8e1393d"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99c5c2fd5526857fc328043ce598dbe09a52b241083cab637ebd6a974ea65bb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40781832ac9d75c2a5bbadfb93b13540f272edb67f13dd0be77efb31e8b1839d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "242e233b939320680721276be6fb636a35fc77964d3e0ed00a62408fec3eefad"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5c7380ebd1da936530c6389458d224ba94a01ee2731b418c92b8609859839a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ad31a65b93c94d2f6605d956d6911ca178d002414c187d67e32f5e42ab1024f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52a3c3992a2778d66768b05ba54ee696027a72aa8aeead1f4a24f03bb42c6c9f"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rover", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
