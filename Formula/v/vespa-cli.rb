class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.579.17.tar.gz"
  sha256 "5fe7efee2ca94e3a068ba2cf237f7e45076844a00ba9a6b42409e1e0539c4a91"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe77db1394effcad2ec865643e40cadf6832c07017eb2cdfbc29008c66a43ceb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f16284d9632f7f9d342915316dd325e1bfbaf4d30b18cd8776a53d3f14875d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1726d66858dfb6e22e602b69d8d07def7fef4125e670f122ec24c7dd57a7c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5157c8d72dde7e7e6833f093278d94fc07e8814efe00568d226f875be65b2772"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5a7000bd52d1a420bd8f38b61eb6f74d6b6f9a4012327a3e31cc070c765814a"
    sha256 cellar: :any_skip_relocation, ventura:       "cb6571aacae1db6d9efd61f144501348986f4274c3ef36fb25e531eb771d7bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf813821b2f7132bf57373584fc1d58ce3adb6c539a6cb5e72ff908a86005580"
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
