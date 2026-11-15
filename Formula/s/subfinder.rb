class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "f9fffdfac6b9668eb8497e661a6ccd24cf83a0f459a41902ad0a782e63b39a2b"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4756202a9368f5dddaf42f745805abf4aeb518114d04995dacb000b869611d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64c7eaaff7b8189c5d902f902a46a11fb34863422596d3cf97738b8ce2f02038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdfe1219db008f349083ea0dd9137270aa420fbbc67ac7bf3c74f78482e0afc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "024d4395e47a92a8c137edfdad1d0dd6219a3aa37f3879a0ee3c6a275b01887a"
    sha256 cellar: :any,                 x86_64_linux:      "c24d5c7cb5a6a93b321f0c97581cca30e4ef27b49dd879b3021a14de263726cf"
  end

  depends_on "go" => :build

  # `test do` block performs DNS enumeration
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
