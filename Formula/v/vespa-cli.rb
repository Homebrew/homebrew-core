class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.763.13.tar.gz"
  sha256 "0dc8040ad4ddb63fe7dbd65632ac64457917dffc4495325c78001e722c83bfd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35db57edb99dcbf8b8a79b27a9b0f9645279233cfd4d201109a132990709981e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "522b220ccc449b4f064aa4a51154d7d88abfd3a30da8cb768b0b6890d5167d5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39aa26c248d8701a830a3fb0c4bb24653f054ba2d4280db005c701b9033900fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "28de80729934b50c216adfccd331dcbc41b8916fd0a761f5faaafa023dac9504"
    sha256 cellar: :any,                 x86_64_linux:      "f2a0197b05f5e53b9bbbddbfd75e23e2ceba90211a0dc0e4967d22ccfb22d287"
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
