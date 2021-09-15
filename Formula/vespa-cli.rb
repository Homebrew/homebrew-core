class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/vespa-7.462.20-1.tar.gz"
  version "7.462.20"
  sha256 "87e309fbdac0bef174ef3ac1bf094d551a54dd2da57ecc52e19880d0d81a9cda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2545137bd5211b28a97ad6b63b19f5c89abc61512424a05fdb115a07dad0f17b"
    sha256 cellar: :any_skip_relocation, big_sur:       "04245ebcc2c5c9d2792fc166ad08829c6b4f48281333a4eeeeba8d8b57d5947e"
    sha256 cellar: :any_skip_relocation, catalina:      "bb874b46718d2512b9cd640bdfd27b935dfcae0975e480b8ff5bf7f013c96e87"
    sha256 cellar: :any_skip_relocation, mojave:        "886380dfa363e839aaacf41d1f403b9e1eb85af71bcce4796f22de5dd555cbe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb17e116100be24ef0787c66e1baf39a1021f038d3597547819959cf8c7eca9"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      (bash_completion/"vespa").write Utils.safe_popen_read(bin/"vespa", "completion", "bash")
      (fish_completion/"vespa.fish").write Utils.safe_popen_read(bin/"vespa", "completion", "fish")
      (zsh_completion/"_vespa").write Utils.safe_popen_read(bin/"vespa", "completion", "zsh")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "vespa version #{version}", shell_output("#{bin}/vespa version")
    query = "yql=select * from sources * where title contains 'foo';"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa query -t local '#{query}' hits=5")
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
