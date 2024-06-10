class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.353.26.tar.gz"
  sha256 "a9022f4eab62de68dfd5230087527d09cd40ced01a0b6d0fc4347386a469fa13"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b081dbdeef3b312b06f25b07c0558529d2bdbfcd836a80522d3fb443a84a4fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b11ec84da31e8738789abfaee17724102ba55149666106efcb8d2e05e6409fbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba64157bec4c57259c6913e31ee0945fcbc4fb0a23ac58b137f37d5c809e6b89"
    sha256 cellar: :any_skip_relocation, sonoma:         "631da3fafc0ff7e441fbec8de81642b375d59f26488f8bd34c995049ade0a175"
    sha256 cellar: :any_skip_relocation, ventura:        "0215bb96e7f8bfae4b3bdf443c56f25659ef7103ab463f269e0816d0c8709f9c"
    sha256 cellar: :any_skip_relocation, monterey:       "72b5844e345e38b75b23c83851f743d03e1dd0ad68650b3a40b5531d54ce7cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f5e614a9011eb34f513b24cc2494fbb0d6e7dc9c13ff01eed5864d4ec223561"
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
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
