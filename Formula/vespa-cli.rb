class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.116.26.tar.gz"
  sha256 "7c10fa12d24e8fcf5811b96594d2e1bd6088ce2c3a767e9479ce0d35eddc8483"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93750e8813c36ac0d42106edf9935c212a8c5d182785eef4a88fda342bb40160"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78eff4658944f1c6403061ad5eae67ca7d55c3189451fb7c1b431bc9b5520efd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d96a8fbed9414cade19cb8157c485aabdc1928ce95d156c3d6f893d6b0d6ce74"
    sha256 cellar: :any_skip_relocation, ventura:        "3248abbcb06a85704167daa0efd71532479edc2f530e74469a3686ce9d691c54"
    sha256 cellar: :any_skip_relocation, monterey:       "0a4d90b7558d30eab152741ab30b5b88d29d6c658ef72431dafc64ed7185dc9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "161ea8f516d2c8ba68aff2f5dd464b46e1f3795ed60e168d08faf4da62f2eb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b183c22af4b9966878bd31fa68adf37822b0519cad07712660fdb5bc019e80e2"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
