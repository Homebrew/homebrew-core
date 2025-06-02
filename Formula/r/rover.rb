class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "73b1cbd858e7051ed59b4840fa1113822985fe233f1042e0f9715b0234ebdac8"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66c284a4be7c4742beba37b794fe8695b3fc612a2ff22c4aed6baffd1754069d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b584bb1cb8a48dd3cdf65ee7e7f439716f4ff0a4851acd894899fe8a79864ab7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a961f3a2d1a48d45619afe3534d1528fc0e6ff6e87acc8ae779a730bdbefaba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "130d42f496361abbd8593493b169beaf6ecb0c0f9ce406449a6afb490318e6c5"
    sha256 cellar: :any_skip_relocation, ventura:       "5650a48dc6ae90a458070fe48f8f134c16fce2ae81e393d7df655dd891ed12bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8394caa1e0712b967d8c738bc71b23301e669ccea3fc9535a30dfdac5ec63ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aced4a193ade5f63292fcda2abbb70e5a7c8fff5a91c491ec94be1414590fff"
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
