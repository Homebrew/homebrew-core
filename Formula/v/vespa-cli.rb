class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.640.27.tar.gz"
  sha256 "803620502d883ce42143eea36548243059fcf525aeabd0b89e7881c1971e9897"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "646b4bcac78ffcb0b6b0efeaee3eef46b8fffd337df8fbcbc8cc8f2dd9ee032b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f7298e0fbc4769aa65f239cad5e5e0cbd9a9f814725a21f16bd088ec61cf42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dadd6e806d9baad201ffa1c273da4e568e45f6b33033b7b04e4594f1098c8335"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1cb1dceb5b9201dd19f05a2be2eb8ba1704392e2c3296d897723c468fcba3fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e5855660885b498c87f52bf9c28d81e117c21840348c2ac34094925a5a6b6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63df08c0867c744712446bc5240fe030c7e327ed84918402ce50af98f5cb59fc"
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
