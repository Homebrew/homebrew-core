class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.5.3.tar.gz"
  sha256 "0a6aef58d7c19db02567d81f227ec4125cc880aaa206365f6dc4f803b4bd2bb6"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c73f9a01d1609d8e0794755f79da782026b672b1a5b6b91da05b6b7bdddb78c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c91429a87e45df820d87836c7caf78c7845a6f96ed9a7ce4bd4b456b67e00b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bce87c9b2f9be1528cbfae3280888556cb37b2887b2953cd1c594a3fa2c43f62"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a344b540b4e634dd8e1e890086a07d0021677cba1864f82e66bcd578cb60415"
    sha256 cellar: :any_skip_relocation, ventura:       "5493465c7a0b6001eddb998854faa806c79834ba79a570168f578d072f396feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300853f72f02636c3dadbe026d49c505d5ee46039db9f5972328f9605f7ffec3"
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
