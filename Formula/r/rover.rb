class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "4d84b790f46397ac609b10f0e1368589368868fc00f3390fdc78b24791989fda"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2a3fcceeaa63a549947e42de05b2a9482f8a717c0b910e5293a396dcc7789a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc80cc14363b750794696eab6e5e8261b361766a625897b7a06894236dce8e25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2417a2c55c355a0e5105bb4447e9869109733b29c32156817e234cb018051c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "177325ce99b866531f9966a6e114c1602659757ad3e4b1afa790ac6ef5da9f20"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6b7f0ff32e0448116a3c1c029efceb64ec4d933d1911ebfcfc14c840d190feb"
    sha256 cellar: :any_skip_relocation, ventura:       "6c34804ea6565007187889364e6804d5eab177a18ac9b11bdfc9ed67de907a1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74057934b2ec9d6a94b39366e04a49d4f8e096708a1b3fc1e38e4ca630dec0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58fb5612b786ceb39a554b5db17defdcf5f83ef9edcb418178f867407a4aeb72"
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
