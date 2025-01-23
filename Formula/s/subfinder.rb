class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.6.8.tar.gz"
  sha256 "02cb9ed163da275909a1509bd1953840eda3c47e4d20923cdbd85c3628512ada"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620a9b1a40d632f32b85e2196930bebada94a28b76c8c278d000a9eeb9159546"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06140ff7fb47358b828e768825a1c3596bdb955ef649261b570807885c66cef4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f1c1abc67c5752bd1ee1ec6db99d5a8f7e161ba7cbeaa18ddae7e11683f5ae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c84fd50b702875084a6a58ffc646cbb1821636d5a32cbe4ed0485e229aaa91e"
    sha256 cellar: :any_skip_relocation, ventura:       "2adc4ca5b5c4f8c2fc5f9afc142ec72789266b1dc69c5c5762798fc0489ac16c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca102c7c94db701123610e894563b21a7c37b19cd49aa9c9ac34232e9a41e7c2"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    if OS.mac?
      assert_predicate testpath/"Library/Application Support/subfinder/config.yaml", :exist?
      assert_predicate testpath/"Library/Application Support/subfinder/provider-config.yaml", :exist?
    else
      assert_predicate testpath/".config/subfinder/config.yaml", :exist?
      assert_predicate testpath/".config/subfinder/provider-config.yaml", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
