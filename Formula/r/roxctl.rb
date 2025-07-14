class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.8.0.tar.gz"
  sha256 "902d994495305ec02c025c06d23cadbb358dec87ec507eddbb0700faafcf44dc"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84a29e4fe4a437e855f9e1ab5a1e0227c3e958531853091ef4f6d6eb4a7138e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4331b278f551dc8ed096e01c6ffa02a0234a83e503c7c90afd2192fbd15dfe78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b65edc71ef90afee27adacf83ab485c1354748c5284213fa5cd6efd71fe86432"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed89dbeffe1e3aae044895a7e148edcc92bf057dc096a8b5128f0518a8ab607"
    sha256 cellar: :any_skip_relocation, ventura:       "d1bc028be3ff4a5104e400d88b658885e0873d6656c569c65d80c56674ee565c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcc8bdd54b74d0bbbbe73e781322c44aa26d2a5a827b806287025c0394a609d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d710aa66c00b3cb5d2533a1796ed4b7dba3efc52716746ad4648b2fc1ca7662"
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
