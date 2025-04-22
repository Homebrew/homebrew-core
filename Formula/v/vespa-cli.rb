class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.510.84.tar.gz"
  sha256 "02944bb10c85ce3a11102139285f63d3ab4ed8d3f31e69bf2a3f58b21ffd91ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ad711de7b4b9fa1e02caf16f042e860024592b4c65f6dcad155172b1e84aa8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e369a290b3a008d3d5d1e807165db1113726c25fcf657cdcae766f78efccb2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22a239867841b63a86c44860e0d9140cee64aabf2fe1b81bf94e6dfd61b71bdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d884da6f0debb2d3310f814315734a752b782a15161c3d5f977ae090757a0892"
    sha256 cellar: :any_skip_relocation, ventura:       "05df7893c774745bb46a9ab39e506582ad0b68c6fc494b6adc0bd7b7106102ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1946ba2e1838c5c3c08f076689836eebc7e064d70cbe28d0626139829c1cf0ef"
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
