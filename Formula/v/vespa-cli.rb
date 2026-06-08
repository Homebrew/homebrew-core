class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.700.24.tar.gz"
  sha256 "7c9b04fa932b24dcc0fcccedda9c142544ccec8911d927e525047506fcb6c265"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ed3acd8cc3923a76c9a67cf0a1e4ee727b24701ebf132d9e72dc3789864ebb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8befa81d2e999788b274d98583629b9447cee65dce6360379e26a7ec3d8c6516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "978bc6138b49048746ebd01f368a0c224d06f8d04db974d611e24783736dd70b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cbe74860148f0af84cfb0424ab85f7a1fae605b42dddb37604eaf021368cb2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7954b3a636ddb6100d1804a8ab6aa91bf3ead1de318e46d96baba97bc03959b4"
    sha256 cellar: :any,                 x86_64_linux:  "a6a1b6688d94a8f61cd90a307659bf4d1c2070fa5d217c6612918b5985406b07"
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
