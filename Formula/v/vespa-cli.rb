class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.515.40.tar.gz"
  sha256 "7ba9d44e2e2a190ec3926bcd40ffe4c9c34dbfe2853faa43772e748da3186b4b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b8b7fecf2bab10bd5f6a1479fd82581883a9403ce4d844cda1bb18acd72fcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad8a28ae5cb76e1b1a2f420648bfa78f50b94385736443352b07a13c94ef6c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5bf4e8207f9dcaf41b2ba123798b2d7fb8930d5a3298d53962b8e2582d3fd38"
    sha256 cellar: :any_skip_relocation, sonoma:        "d54a6d85d103f03dc4df5333fd9b87bde6263fab12233d5f7e9b7a0ea18f6fae"
    sha256 cellar: :any_skip_relocation, ventura:       "1da92e87b8450c9570faa81e434acbede8ce6d1e9b1bcaf6406a862fe0efd71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0809890f83d89a04a174176f87382f8bdd28bd220543c967abd18d7c3c28dbb"
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
