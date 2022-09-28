class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.59.13.tar.gz"
  sha256 "dedefa7e4d05e7c601e7743a0c4f6d31198e7a7fb0b246a54939a8f880e8f842"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "955dc02cb1ede448122c392b778c82dd5e4bead0a2877e2d325e194c95d7a090"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16b03600e40868285cded563e64c9e17ffeb602616013952d879b5dcff77e958"
    sha256 cellar: :any_skip_relocation, monterey:       "9ae5efef87f797f620f79b3e6c1277688d407a57e7f3f772240e256b4f36bd17"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a047b227bf2ad4f4945513db6af683fff81a04e2a13fbc1018afec8404e0f6f"
    sha256 cellar: :any_skip_relocation, catalina:       "3c8c3f76b93f787edb8db0b9a4f775e0917a3ae007492688d84b984668e4e014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180e6d16fa8ab3d8829da5b9aae1b79b0c688cd4caf22e8a87855e7b14ee3a50"
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
