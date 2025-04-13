class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.507.34.tar.gz"
  sha256 "7d6e5f90333babe7d6ca5edfb5496a88eec978f4bf9c0d3c557a60e1744f4c30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1497a43c92fb8e94b10ff3e585fb7359effee77bddd427b4aebfb2366b07d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "563cb7626527f25921ac0d483b97dc3a58ad892ab514d8686f623d7f67bef71e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f6752a3fd1e0948276527c83fd55548fb7e92e284d45a09399f1b4e5618eb04"
    sha256 cellar: :any_skip_relocation, sonoma:        "26a5832dabbb5cc01fcb969a3fecd8f4b031b493f7891161fa06766f522a4966"
    sha256 cellar: :any_skip_relocation, ventura:       "3dc9ba4ddef97c8c16c794ae908eb4eb0f2b4d9c24e7b458bd6cb64a654e4b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab1ceb5d2448f42c4ae7c9ce473c748b3c5c3f167080eec901ba38d7dbfa876"
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
