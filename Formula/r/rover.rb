class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "b3fedba3eb6abe9b97b39aa31e8576573aa5884c23eacb83c7954d20f517a2b5"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e57630544509a1adff4c4d4a58e8a7bad02ce671942317954842f6738dfd490e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a3f46254c59fd7c5e176619c752605925a98529661018aaa6e2cad777129f03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8f752e81c922b7d1fbc118171d59f747cb081bee9b8dc4019baa584fa99b8ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "71aa6398e8f89c52d10574779b8ee4d1159b2e7994eca5778320484641669e47"
    sha256 cellar: :any_skip_relocation, ventura:        "a607bb6f57c7f40af9de0a2194c8a5371f7b4461aaad36ac2ad70609fdfd0e44"
    sha256 cellar: :any_skip_relocation, monterey:       "b37bd3e5b08e3f64331e56cf3780870304993a449c7ba1291cdd848595f4ce8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea978cee68ec1be5a90fde1052271de7d3ad6ba18a6f8ccfd762da2f3a7942f"
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
