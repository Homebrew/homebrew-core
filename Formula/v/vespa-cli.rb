class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.788.13.tar.gz"
  sha256 "25a7998badfd6f64d2ec403cac94bae5627b6605e603372134d297d243ced1fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "e0ea2e220d120999b442d7fd2a211ebe041dd7d112cc08f8a6e4e1c8a58ac915"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a104580751c118d6b663ef92cec12c2c2c4a546f40f9e550d41b4a67add15e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a0923c7dcd5600ef606581eb10f300c50b31090179dd5287c3c208a933b6a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "32dbf671ad697ca85faba6ec1823dba413c3c90b043c38d6f254332b4fa62742"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a7b8aa08ad37b1fab8f6cc7b0ef46a0ce2758e76fb1b65f3c1e3d59e304e055"
    sha256 cellar: :any,                 x86_64_linux:      "3e3683fc297479cde226dfefdf691d6712b851c88ecf18a8f08ac80766c58b8c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "client/go" do
      system "go", "mod", "download"
    end
  end

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
