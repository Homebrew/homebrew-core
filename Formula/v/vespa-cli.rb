class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.629.20.tar.gz"
  sha256 "b956da83c3b46c87f8aeef10a1af80cc7ec8c5a07feef164eb7f3ddf5c16aae4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3b45fbc958a5b936a193fc283d7bc39bd4dadd420a6ff483a65abf817027d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f86d8a8f1f9edc46e39f73f207d487005103d2444032a39a7336e40ae577215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f40d198decd00cded3f1d338f98b251e7197b6b01fdb265824d546b63807a7e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "94f58b8947eb115d6e36d51e48b652e73de8204606669385f210be9d6c0224b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38136df356f0039d135f4117c7bcc77aedc61c55e973fc7ebde3732c2ca56357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce26865cc59f8b23b41e989575732bb5fbb397f129c15ee7bd7471541b3bbb24"
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
