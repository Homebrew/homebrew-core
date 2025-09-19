class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.583.10.tar.gz"
  sha256 "41a2264ce64305626641d8bfcf5a94f869792a07e34a062173ed95a348370c92"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "676cc0fc5478626c5425aeabca021a111d55e161378de3ce55f81fb97bc49141"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363d3ee3972a02fcada2ca8d12065eb54b8f1e732158372acfef315628462070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8444adb33a53d311489a344ab9fcb14931ab3615b6750b4f6e53f452ff8b2b41"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ea13e0685c2304eccddacd0eb4fcbcb27590146da93421242d0f12146492588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8d836ceda613b6001fc688467310e49790081634b3403940084dd4550bec6d"
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
