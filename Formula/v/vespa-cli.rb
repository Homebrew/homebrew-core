class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.753.16.tar.gz"
  sha256 "38158f73e68b982e4a4d688d7a31333b03cae5ea2b67be64904d93c67f0d1114"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07fbc781a1f44f7206bc84709f27d96d8e7654520a1019148c8e22faca95dcda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16390d3645f737877fdf3b12f8f2845c5ed1ed14564994c6613bfff53fed725d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1856ff34e439adb63ec3aa5b84507e94807bcde6ab441b3de416bfc7c3cbbb4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b3cbf77319fb1d3bc16f0e0c95b28470e6d2a2b00a8069e02b9cadca3cbba92"
    sha256 cellar: :any,                 x86_64_linux:      "49cc6cb70239ee5563858db9d0ceb201b2df0aaedca81cd5846b9b0b447948ec"
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
