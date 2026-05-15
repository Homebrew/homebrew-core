class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.687.75.tar.gz"
  sha256 "50935cf00062f1762287bbfe7f8d7ff0e84a90a6a5d15fb27e2c398765f0bba6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a005743b923d17b0b422bdcbfaeed2739f3081bdd0dffdec7f50446a4cadd58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384d9b62b5d1c5ca8a7f01e7d2e0856c149f75e367481367858d8e8241dcc3eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e66eb92e067fe8e89e6257a7e06fe9303953a69714bc0ca984fac7b9e33ce36f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8099cbdcfb0f59e0ebfbdaabaee4d267563966c0770cfc5a20c7d5cbfa45de6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "820139327fd7c379bf3fef643355df7233e0db4b043bd8a96c526259d1d71193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd9b762da3a80e7c8bd29302342127db0a87a8cdb987ebcfc270a7b2f4c47c58"
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
