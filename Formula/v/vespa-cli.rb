class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.608.33.tar.gz"
  sha256 "22612b09bcf4b2a12c763d461a1e7e1f09db2345eb0460d3da7401ee90bdd7ba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a067a77f1b3f0c27d5d17d203fa789248882b5fe9375b5341cab16cb762ce9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386b6762ab764942d5af22b7006723544ca9a40c56e471bd58131741bde393f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f84d96d0b6e07a0d2f53fa4fbe4f074257f76eb6615353f8836b40d0b309890c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a776eb0562959e2f657d6f206432469e7d051cef47f42158101b95f6781938c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64cdba4fce6f1a43c553c0a65fdd064cccac303d3642c70510940d26e240729d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfee0f6b1ff2c2db0342a79444f61a9e6ff3a1c0804ed9b1ff4129e0259996c6"
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
