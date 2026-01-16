class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "d93856caec7d0886b46ba34a44d0784b63980cb170cbce66f81b08057026754a"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e755a44e41cf581115c4a33aed936d53fb54822903d9d2378f8853b2ae4e0fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb7975a257705637ae60d7ad97230c8421e8e1c59ed0e2422684d47879aa8862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2108d7edc751f89ff03ecf42b184074dc08970661aa93d6145b8a80e0d20c404"
    sha256 cellar: :any_skip_relocation, sonoma:        "1200527113d4901fb2c7a3302d1bfa94fc42bcfa86fad994adf02743c585636f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "529fde6809c33b69e9e51b0e6744db5e7cd37d94ffc139650877b6c1199ea111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc4bcf338b3edaec47cbcb05d77e5ead00a546c231776a69d0db8817178099b7"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
