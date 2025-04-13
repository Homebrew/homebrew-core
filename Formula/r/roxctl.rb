class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.7.1.tar.gz"
  sha256 "c4cfc0fe535ccb9b4cef9fa5b9b7156735f8a1cb7a94dc6b21088adee3328046"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b02ac5e3ef0fb8e696f37c9d46d34a277b797575076f9966005eb17593be143e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c5f55b7e22f044faf0d320dba9c19d78a0207a2fdcd9ffcf314d606c69ac00b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c852f803ea0208bdf542e034b57a7db7766c537cd4e16e0166b50b797d5d17a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b94546d397b4fa6a9ddaa732db8a810c53a4fdd8946c80f042f43c4cd78950aa"
    sha256 cellar: :any_skip_relocation, ventura:       "4bdaa6fc0526b0c203c094ab464801ae04af0096a2e96701e210660b7cacca98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bcd712704f5839a8e4edcfdca6d2f9182226faf8e00bcf16c364efd1d55aac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28abe05cc7e62bb0c65c67f35218a39dfd483c2a239c265f66e2532724f92a82"
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
