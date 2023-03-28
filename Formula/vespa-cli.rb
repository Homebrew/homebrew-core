class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.145.27.tar.gz"
  sha256 "7bddb72c697d5865698dd07192a14dfb272c837e138973146b898172bed2fb74"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc838330b2177c7b40f729cc24769e3264fe1318eac5d9d96beda611b4c304c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d758251df19a740d08e021b3c1f80face1641d5e5c75e2c637c099bed47786ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e26265f8418f36276462aa7322194f6433d65a275b2249f3b4cccf79d5fcbb1"
    sha256 cellar: :any_skip_relocation, ventura:        "6442496c6f50a35ac93790823690cd63b7a7d63dbffeaebdb1102abf56632405"
    sha256 cellar: :any_skip_relocation, monterey:       "5c8d51002c9bb94e683f7a027398ef5b392a275f06fbd7fdad945b5779be3aee"
    sha256 cellar: :any_skip_relocation, big_sur:        "35f122891a381a3fbd624ff433381d9e57bee606e33548f4f3329f114f268fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9858443b1f0c9908c3e35b89b3b7808a7485aaf460c59cc960b392b792857c6f"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "all", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
