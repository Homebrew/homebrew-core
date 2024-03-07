class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.315.19.tar.gz"
  sha256 "3ef07ff31e3899596e4159784ffee867eb1502669439e469c74567a1c77ab789"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bac92f6802550249ae6e3d4806136ba2d0c3f1f1c8874c87c3eec12fd76efb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1701561cc0c365df5ec98e60183d76ef57ff45c5aaf15f43c14937eb71b65e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1513d4f5418bce4a7c1b8dc17e16787c39ec21a61525c66b086d34cc54555762"
    sha256 cellar: :any_skip_relocation, sonoma:         "1be69d0cb2de242d374e3db9fcbcc8e3fad6cfa7286b83df51306fb2c7fe2f61"
    sha256 cellar: :any_skip_relocation, ventura:        "5a655666a6269bf81fceb547dfdffe56234423c494a02979f95c6d4e9efe5f13"
    sha256 cellar: :any_skip_relocation, monterey:       "ab6f8e7f9ea0d46c750a4294ac76b87afed753ac9ce6b504ea8837d4994adfc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "894352744582b6e2cc9873d46d3ea0bd656872fb740c393943ce5e11db6b07fb"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
