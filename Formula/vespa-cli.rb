class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.62.51.tar.gz"
  sha256 "e0f0e0be7ffe26642873a755863a80517935aab841811afdc56776ed70dbbfdc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3762c773442378d3de77ad3c16165ead44ccca5a633f8dea056ec8b999997b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d9e7352ecf5c531c30c2a87a16207fc3ff8069ae37967f83058a96e8f4840a"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7bb6fa5e75fff1cdeec0f9b0a512a776d1c28f993c633ec3f83184a87452a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccf1eae95b12041b7e535ec35f23620a3832271275039006d95abc4a0ad83f54"
    sha256 cellar: :any_skip_relocation, catalina:       "253e95b0c830bcd1231eb7f032b80c380e0ae357c3d9c1fcd5bcf8f973a50054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba128a1dc1d474e20ee78fc389b4040953bf0b0d521fc01588b46bc57ac5722"
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
