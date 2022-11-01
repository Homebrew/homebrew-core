class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.76.18.tar.gz"
  sha256 "aaa3dbfdce8c78bacf4a11d1099fd23c7827a6f4f943ed8e2422a351ce1f856b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1ccab483c7b2b424b4aa294150c1996d99894749a4e68cce5c0abb59d2c22b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3653a82a878e091363579a714a11aabcba3e970f9193f7d882bb4c8e5478942d"
    sha256 cellar: :any_skip_relocation, monterey:       "7e59e106ae5e5d3143762d51c13723821a178c18fdf0f4392d201597c861e90d"
    sha256 cellar: :any_skip_relocation, big_sur:        "da343e84664d4628c78f8235d51a32e0d333cf6be792fa755f0d43396f9a929c"
    sha256 cellar: :any_skip_relocation, catalina:       "851a6178f53b2845c4cfbcd3257910a158587926848f5053316a42217f5b31d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25bd222ca4ff938c2067b8773ba6f022f10f88e57db0e558df5fecf12614dfb4"
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
