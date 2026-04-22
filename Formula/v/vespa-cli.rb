class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.675.23.tar.gz"
  sha256 "63ebd4b90b23c853f0e24f662babc6119bc4a1dfb3c3f2a9458a661dcfa129a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ff4d387fd1efb5804015ed2bff4682b0e8830909d5c8d838dac69e03eaab772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a822e6a668930e7cd1be806c4f1c2c9b01b66a18cf53c96d4047ebb202d98bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d65eea52a07178a70692f1c1cb555d3ff1433f589978628d2a46e971cedde34"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9a16743d1f036d3964724b456c29edbf135e220abfcd4c572ffecb1b3dd04e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b77a470590c071fc18f3ac09f9e4aba7921a2a5439b99e1e3bf0574a48e922a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c8618aac37c81477e7ce58c5ac22cacd0a1ce1a70f6543c1e4dbde04c1dea6"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
