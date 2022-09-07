class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.48.22.tar.gz"
  sha256 "2038c013eda9a0898af98e68cd731ad0a92bab6c1e0ab40ace9a00fed4061c30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "880b00e5ac1aed8f25126fd5a6cdd9bd7b51f00f42b68f6d790c60889832a1f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8862d6bc57958a2161b375c890ca0ac7f15560c447b9116f9dfb1003aa37863"
    sha256 cellar: :any_skip_relocation, monterey:       "b068779d1653cb3715a26d021cba6838dc10f9ee0e0517c0435b0823184576ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c555d717f84de6d02f4f721a1a6568947922c78b5d8e33a23f4f520ac07a18b"
    sha256 cellar: :any_skip_relocation, catalina:       "e88df20c041c73c2a1bf3ae20b0effca548f40e3a4c6816c9a597af1ae86e211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa1650bb9cb08eb072cec333a8b9b447dca005bffa899d846020d796c918792e"
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
    assert_match "vespa version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
