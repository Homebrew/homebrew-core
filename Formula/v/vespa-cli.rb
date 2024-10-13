class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.420.10.tar.gz"
  sha256 "e01d7efcf07c29cf3776d0b232694b6d2051e6688b4c12eeebec4560f093891b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28da1177724cf7267b0a6101f62def7812583f3ce7d0c73f231b3b65ba86e403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc4009b57f9201ad4f9baf5b688531d7f11b1a88cb43871d967d28d6a285210"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e917408c1b14300b1e9416e43608c19959b57d3b9434ed9960975611314fb2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b91bb25b60f0f4152fe90d9cd1d2a2c3230a1fcc9b342b89fddd1b0cdaa99453"
    sha256 cellar: :any_skip_relocation, ventura:       "1e6b2f04ef77f62b89c19ff9abcccbb5fbab3df2b2183d38faf2e8e2a774eeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcee6c3ecce96088ae5319a943b3cc0261aec014000e13fb983035c28f6664fb"
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
