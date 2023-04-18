class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f93357b61135788a0b76d0dc6cf10cd8235ae58fcc1b53b953138adb94d48b9b"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f252ef51a04e0b6497c9ef0faf14e4372c4467f22d3c8f8d579b7a8dc7f35557"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f8a30f14943b63cb553cea2046701e96a43a9424dd35c2f0db38c15e3acfdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47e6f4086fac6fabb4d03a7d243fce6aa0d1e306e063e32bd0335235ca10d0e3"
    sha256 cellar: :any_skip_relocation, ventura:        "db4c8f3dd7d6ed5d1c3a6adb4314b0235dad86f6eb02625b692940d23cfdf7d5"
    sha256 cellar: :any_skip_relocation, monterey:       "4f20df0fbef330ea98467cac5721862d5070d31dc37d580769514c5a8194a8f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "07add52eb272f13bd17f7b3c4cf9aa6d3641662ee4ecec66730c2960a8031d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "838cd990e0cb7fd7cd49861014e36cbb3fe68c28baebeee0d5dc2e6847d97088"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
