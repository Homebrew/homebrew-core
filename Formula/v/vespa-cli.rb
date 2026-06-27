class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.709.19.tar.gz"
  sha256 "6e20533b5082517131d6ec5ea28043b99d25c5f1ba5267f0f981fb4e0b501007"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d351c4966eaf742dae2e396e5f82b6599e993906dd31de0ead6522a4db3be02b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a3c2491e9634ae47bab485743b9fd84fee507062858bbf10cc92630b8a3c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d9594b4d7cdc949d32b61268bc2b6bd4e5a190b79f9c6d3479b71573485ec75"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd46e7058f5a22b273a089d95e77a04c947e047bd8eca6fc2b126c6ae6e39ae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dced6a9b323f36792d9dd4bc515bf27bfbdd2f383c8e40058079e73d4afdfec0"
    sha256 cellar: :any,                 x86_64_linux:  "ba1960768552c77747a502b319071072f6d6d3ab46ef8f9ac18179fee40c0f0e"
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
