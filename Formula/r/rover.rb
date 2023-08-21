class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "6145b5e304220f4210d251a0c408414e37612b8fc37486b98d0dfbd18d15d05b"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a52422ee2f02e1e166a4b0420490aec132af7ec021caed687e2e0956032ef76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b5640fb576228950a703dd19f2b6dc17baf35c4a16b158eb2bd74417df76d4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e696a8a0e6552f43c4d558fadbeb854d9e71f0717be0f4cd18053ee270f38269"
    sha256 cellar: :any_skip_relocation, ventura:        "739122aa327786cc4e321385e70ea5b531c5bae98f8e29c989719936222c879d"
    sha256 cellar: :any_skip_relocation, monterey:       "94ebedb67204308c42adf1e35fc1364240e649589f3a4eabe6b0e94348b7deaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "6175faf9cf2ef0ed94c9dcdf08aa012150906a903eb9a3711b455760a80aea76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f0773cd0d77cb8f43d9b4b5ba51714312eb06bf6f9fc5ef00f20951be4a9b7"
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
