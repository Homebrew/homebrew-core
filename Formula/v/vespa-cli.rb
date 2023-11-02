class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.250.43.tar.gz"
  sha256 "56b6fb372a67cc0723d12be5c23da90940b74a12bdd8b51975ac80fff2926f59"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf8c493d756963b89a7ba0f79f3137571633b1704a6845bb7a1fd1cc9aac3de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b1406d85a480febbb28a6b29b7f78223af092e010dacdcf3ae5824c70205975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821334c125421cea8c3bcd77ff795a641eb68585d6572f19268d7e10b31b8c04"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4faf9f94a10d2640301be89dc0c39fe3b87ad9964146386af06508c64b9efca"
    sha256 cellar: :any_skip_relocation, ventura:        "cb8c65b12bd3f575b4f762e93cd9d091624cf7432ec547335083f1f93a56e47d"
    sha256 cellar: :any_skip_relocation, monterey:       "0a5fe8984a5b540031341a9c3262f0d0883f26b6b1774f18df12535adc1a369d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87b021d35492a8861676a7ff7e0c6e56597bfde9e3d82de18d4d16763a1dd719"
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
