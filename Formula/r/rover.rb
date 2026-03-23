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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98e2d9ad561d1a16b2f91c1259c5c793a9c26a292c7da254ece29877622ac7b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f98a2d429fc13478a5e9826b96f5f9931eb5fc87a03f2c4bdd607d5f0e384851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1508a4138bcda8541e7c62bc7ad9595f10b64bc5177c27099c9d3933930d6e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab791df636a3fe728b35287a972ff2ee3c255257e0dc9025a6e84cd9cbe5bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1bbb95c462ea62cc91a1866b91211f3f4ed403c2fb1c0079109079bb20f3e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67bde9ee55f25f7ad4c3a0ab72cf67fe2970e254e6b3677c90e42f47bff81d79"
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
