class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "12b1f287b56a38773d83f995a648f2609eeb289e773583c53b6dc841d6d52d9f"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53a1aec5a37af56a618571dda7556921c581a472b67aa73b9abd2593ffec6e25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8858eaa086f43fc7ac0057d23dc64a779c8455f1477d190e4938f737f7e86919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc353e8165610c1259293f85ad1992308a2007b2066c3fb05577ca000db9935"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff40accbd536e2c1627fd3515e79ecae8e5b6ea3db8bb6eba5759e6663b63009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "334afa830ef71b76d71e02a9a360bde425e6d2dc9118f0ad5ce33086db05371d"
    sha256 cellar: :any,                 x86_64_linux:  "14a985a9f3a5ff404929f5c99496c20f4e8b04268d3b510ded5695ee568a2c90"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/subfinder"
    else
      testpath/".config/subfinder"
    end

    assert_path_exists config_prefix/"config.yaml"
    assert_path_exists config_prefix/"provider-config.yaml"

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
