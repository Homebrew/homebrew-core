class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.106.1.tar.gz"
  sha256 "811818e62c4434469db74c0c902b51565ad431b0c9becd4883a502bcff2037eb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b79b95ca73ac69cc4ac5a3664ff818e1b132ac683d3fe6dfe5b57e236c6ee988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c31e341659a9de0a4ea4a606aa2d068ce7f75bf3bd3f17099265afe4d1a3e252"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b6f772160ca55491fc0cf7a3bf6fb6fc58936734f787bd5dd7c7dea43e38c25"
    sha256 cellar: :any_skip_relocation, ventura:        "288ca044410118cb0b5671dab5f55a7b36bc7329858755986e95e487942c5322"
    sha256 cellar: :any_skip_relocation, monterey:       "79123b10f309de331cfd95974278d8ee7c05990f018fdb17afbafd12bf891b52"
    sha256 cellar: :any_skip_relocation, big_sur:        "31b7100a5e382226ff93924cebe5de7ba24aaeabdb7356bc9c0e3004367f7af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba8e05d05f0bfca6392d21f0514533456c63135c973a9db2d45baec2a7856876"
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
