class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.781.11.tar.gz"
  sha256 "c6868fb4dc645d8119bf9b09c5857b4ecd38ca47a300dece07e94ac30ee09101"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6d589ba423c362a3d062095f8d23b9fb3f7a9a72e89407058524e358d012409"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e37e9e2f94836102660ac4ec8c3985ceb607787893a836adcc4492d6b402516"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "077060f1ff924e4d6552e4340bb0d31fc023c11a2fe98cb36bec56bf9b46bc9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd090220e27366cd53de13e094c3d00e2b4e07b8afbce3acaa1b029a38360770"
    sha256 cellar: :any,                 x86_64_linux:      "f438114ae3e6424c06330e6c8e4acb0b218ba719ccbab5679da9e9bb1b6c23be"
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
