class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.533.16.tar.gz"
  sha256 "1fab196f5bb78bc121994530ca32ad061329d55231c709eeca446f6880d43f68"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccf680c2bf81dcd6b28fbcd482d9b5f7ccfa3ede50e6acf82319b0de2177634a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82f62fcff5a548313f47080c3bdf380a5bd5bcb0639888d58f949107456cd9fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9c4d57817ddcc0416587427c70cb2d17f52f0e42a1e89cb913727362d86f35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b1bd5b7aa2ba3f6bebd76162c018703d395aea44315f228d017d8a2739c335"
    sha256 cellar: :any_skip_relocation, ventura:       "97d4a983ba22044d384c5e4cf893fd49f17ab48a31b77daf9e72a67d126dcd20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65df98a9511de773f7b6fbd6b1a3377f1fab009097143fa957ec0f9af284935f"
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
