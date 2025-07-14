class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.538.52.tar.gz"
  sha256 "27f0a6f75223230703218ae3f43cc17c18b371c230b3379991430e71219a5a01"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98b924646a8a4d43dc90b03676f63facc86be64ff3acd4f20e000a7f3e3f3e9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "318c92d4d2cd9d7f0c7653a88206ec16f08b0aad1209e1ff6705f1f384745769"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93a1f8f8787de56f14cea83ff61fa28ea97173d0b6433284e5a0b1a8d6d564b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "56077f0d4f2068acd7370952fd4807e7a77f31fa067aea1b72c912c217228f1c"
    sha256 cellar: :any_skip_relocation, ventura:       "975e7593793b11e951a29b0402828976dae8b8a935b62c65e6f03c332c5d9482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d3004c0f94cbc05331ef49c5ef4247232c10bb7c1a83b4ffc2cfc4e2154266"
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
