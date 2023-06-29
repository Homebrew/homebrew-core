class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.184.20.tar.gz"
  sha256 "b3d79104f697a14aaffb56d7acce9ed640e6334060cd7b8827718fc1e378a12d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1db336161b48a9a3f6d81c27e53c13bf47e46d3d178af635cfb880b5ed3961cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a229439b8af5c72da6fe62bf67e8f7e2d8af1a793368779bb263fb184bfb01ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c5caa44eb90721eb78c228d3c0d38c61e7a30d1b7fba3b9511aaf48a5152494"
    sha256 cellar: :any_skip_relocation, ventura:        "6c12e62a92920baab4d7f8b50e4971d4da465ded9ebd4aa860495ed725c3fe26"
    sha256 cellar: :any_skip_relocation, monterey:       "071383514b73f8384f0a8db2075bd33ea5b93819ed21921ce253dea8915edcbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e31222568ac52a75e1a9238783f2a4683522383b030adc80127ded846baae6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bdfe9c0c51f53c2a9bcc0cc72266ed1d702b3b54b873ef6417876419fda163b"
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
    assert_match "Error: Get", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
