class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.77.26.tar.gz"
  sha256 "1602d56070a0b3436b64d897a4381af131d3eec15d1cde4398390822e0cf6801"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d76c4b5e223ceaf39923bbbf1dd8bdb05a7e1f290b63b62ca640825b00fa4acb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "872682b5f392661f9ea1133afb3f0fe4a01a102b049219f11ec4995fd38fc584"
    sha256 cellar: :any_skip_relocation, monterey:       "e12985b9ebc173d7f3acd2dfa35daba73a7a32e351c15cee37fcf90a6509b20e"
    sha256 cellar: :any_skip_relocation, big_sur:        "33934959d0684f200e2bc719e9c733aee2b62552e22d715a8e5a0d29902abb4a"
    sha256 cellar: :any_skip_relocation, catalina:       "021a81056d61c5c42fb655ecd30b2633a230d29a51d7155c02de05dbbc40b6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6e02368679de02d2c41d73c1294a24f6ce495f3615172e035d8b00c4c74e011"
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
