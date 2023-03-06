class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.132.43.tar.gz"
  sha256 "35612af892893be9f9d1dbe02919ea0532e32d95f1765b2c200aa73aedc105d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1dc969613e914f1b6d358fc78ae9f1e3769fd60401ea1d7769a6ff3922b60d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bca4beaef2d49ea9060b4a4ce029cfc7f2614325e2cae6e73947a68fad483d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "345f7892210e144547e48435955cf2f555194076fff7bcc82aee85f14bbe2f9c"
    sha256 cellar: :any_skip_relocation, ventura:        "d264d4857d4a462efb92590ba755c07f88713a44f8d506b7905ee72fc5ae66eb"
    sha256 cellar: :any_skip_relocation, monterey:       "82c52f4d9535f264c311febdad2dcd677640b7a0d77f4c77f77d24966dc1c808"
    sha256 cellar: :any_skip_relocation, big_sur:        "6817815ad20b5e28f2d1261fc2c8b7345f7727bd4bf697a9050204bd0acef86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728e7717f81cb393090bc55f24618a7ce4456d2fdd7bd40249b516faae7de72b"
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
