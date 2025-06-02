class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.7.3.tar.gz"
  sha256 "5e6d08b85446d36dbf804cfdd9468b339d78b5e7fee72415be3b233faf775d98"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac8c3e8bcd6371dc472620797137d648d7986d912339e6af9c79c35fbf6ffb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aca654c20b635210618ac9a887df28dd5fca6e38be55dede1510ac2e4734154"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da90686df6007e0ed53981c9e0fa0389e9f8d66bce3669b7b14e28d75f3f36f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9e1a9df31e42688987103592beda1a89fb949d4535a1137ce0ac90eb2713b80"
    sha256 cellar: :any_skip_relocation, ventura:       "62daa61b24b69c0ae5f898be75fd6065a1c7f7fcfa39adb1c2b306adb4aa314c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3ce7e447d322c5f41a54e6cc439f26b7e9d6cb3e3c67ef06c9d4bf1f54c1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f9e4dad320346264fb4ea364fbf736660a674623e43ec82019f36f5b0c843e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end
