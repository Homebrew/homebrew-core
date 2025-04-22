class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "a939f21b5bff0fb255b39593182f6a2f3df1c5d47ce63186616f069a5a2c4c63"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55f572baf87a28d3eb7fc2626cf6c9e4c4f0337f1c39e4edac1ec2292a253165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb822aee95b3d2d9053f935e3bc3dbfba5175a3552a9fa15eb52c26c1d8b3b55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a12d907791cdc85a73c6c9a7667f165b9fcbe996a731b5788603d47f8e7b5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f99b9984fdd03da220abdc46d60140b58768fb7aa73b81877e77b9f7ef0284"
    sha256 cellar: :any_skip_relocation, ventura:       "0eaac4e6a24efc9c6aa6decd698089648c4014e8656986f9d3c4acad95fceffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52927161b792391437192869974e5a6863be2902ee74feb964e3dcf41aa80b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f638ed02d714e355471c83fdce8c546bed2dd10f3e76da9d5779f3f561c0c43"
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
