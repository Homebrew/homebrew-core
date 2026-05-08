class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "7254e906b6658082f5ef3788289a5d7247bba8b36b289c50d664289651174eff"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2cf43ae09a19190215f3f6ae377f4ba6fb57eaa0ee796c51d761588d34b0eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98d509b4b97a2c362f33ed4f1b1352afa4b03fa4483b8e39b4a1a3b0a8f1f1d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f10ee7e3049e217d3f2f0efe8f73ad72d4a3cc84b1a3f57e2b9e082a48fbb3ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "40f7851e32faf3f0a49019dc081ea0e706f9a2542ef6aa21b2818ccf200e0a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b1adee4386cb4200d5b8422352dae102f050836cd4e923940134c4b875d50cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7ca83b421bded41d6cb030ad4d43b336dc898925f51ae21455bc7179fd9926"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
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
