class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.466.24.tar.gz"
  sha256 "54655124b1c41f0a8fad0d0216e281cc146e020fa36b167e44636b05a495b869"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "645f343d2d19faa79e14bbb1ca122b692087352812f0151ff4485a75da0816d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53469fc7be99bce3fd11d4113ac78dc41b979f18574fa6fa8703a0f001f18f65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3733863d288890aec7c11761470e5d9346c1375659c480b0a44a66cf2b6b11df"
    sha256 cellar: :any_skip_relocation, sonoma:        "58c9e9e6f74e6a843d3116f3d52ac250f03b24e72b7769e8ce89f7a41bf256bd"
    sha256 cellar: :any_skip_relocation, ventura:       "63fe9f8c767f742decf4f471cc4d7dbb26a7fceb052211a99701038b97776c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68c5a929cccca921a0376e22bf0234754a7f3d80588b678a7741e53d255074e3"
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
