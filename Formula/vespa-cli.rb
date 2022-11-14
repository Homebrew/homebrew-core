class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.82.24.tar.gz"
  sha256 "684f670d22fc3bd1ed2aaba46b74cd1e53ee77a9bfb57590a501f5acd165501a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd94000889116d9937b0026a1d6e272bfa32e8542341000a6716a3320417eb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68ffa1fd94046cf23aea5974916b3abc9e851643090b8958755a7630d6b67b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "375236ea0ba62c416a43485ab8eef68727f8544122c2c4fe8fcfbff84866d47d"
    sha256 cellar: :any_skip_relocation, big_sur:        "009fb8cf208b2eae67b7c33b1e8b9e29bf46817d0a1d45ec69b7c8e81586d399"
    sha256 cellar: :any_skip_relocation, catalina:       "7962d111ba9fa2b54aa4a766b12f4ba990f1f4cb1be590ca1b5f9df18401ccd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8424f44940374353f1f1f0df0b585d3ca80c77c49258e24eab398eab04c48d13"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
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
