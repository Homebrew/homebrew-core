class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.586.25.tar.gz"
  sha256 "3e3be655b52420b19d57f4d45e5dcb621bf2488c71432a2473c10ee79dc091d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06f2b6b1096a663f38d6f3c6d6c320e97f62e3e33dc03591d626c3a13dc1b99e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3b45f4084067e34f85fe32a33b2b649f3c1bd2e9ef19ec240e350dc33e9b26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba63f85b4195d89d6dfc9db7e111d56eef436370356c31f0c826e4649ec5e11b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5a6daffb7f7dd4cbb0808e62127e1293db16752a9066103bdc71940fdf4c749"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9f102614f55e3217e99db8d03a9a049255b48ddeb483d75e533821c81e5593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67cbc9561eb67b1a6538670798c4a912ddbf034bfcb71b1425065bc149553043"
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
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
