class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.314.57.tar.gz"
  sha256 "23859baeea2be31a483483061dd9350f1803aaa4705102010a9e110b13dee4e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66c88f2cb67fd9bc85f92d8ceb597fe5aa1feb7a091571ec12176885581b463f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "235a02bb836eb1207eec1ca1b6bdccc26a833901a3d140c902bed19ab74f18d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fd2d1f6bd2dac70964f2a1ee98a43989715ff53f20367acc839ff68d2e42489"
    sha256 cellar: :any_skip_relocation, sonoma:         "27b8fefedf80b15dc6531372dfd75a9d18ce4321a86b0f158bd65af6c006d365"
    sha256 cellar: :any_skip_relocation, ventura:        "9823b0412a52d31cf97757434a8e39969178b00568655fdc9fca99c4cece314f"
    sha256 cellar: :any_skip_relocation, monterey:       "c4dd1761311b268664d5fcc4eb83f8d1b8f6a9c63ed0f7ee57f84019e49c0a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3219e09776d9d0347a8b020fb9d8195054e077e3b4a2c6bc0d1b3c7c1acd82d"
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
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
