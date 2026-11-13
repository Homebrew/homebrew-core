class Vcfanno < Formula
  desc "Annotate a VCF with other VCFs/BEDs/tabixed files"
  homepage "https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0973-5"
  url "https://github.com/brentp/vcfanno/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "6a13fc9fe247f2726b6294e55e713281e62e4a5c279501e60763c52c4c921d45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "add49d2935e062ec8e5124edc49a76dfb9ebc14ae64f8f40f7eca6038812018c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "add49d2935e062ec8e5124edc49a76dfb9ebc14ae64f8f40f7eca6038812018c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "add49d2935e062ec8e5124edc49a76dfb9ebc14ae64f8f40f7eca6038812018c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6430d2b52aacfa8e659e8dd13ab228f8e85da6dfb60fcea4234bd7a9923c5f11"
    sha256 cellar: :any,                 x86_64_linux:      "15277a0405113949f916a5ff6c5b839878ccfca5f4bfe5d41c6eb999116a0709"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    pkgshare.install "example"
  end

  test do
    cp_r pkgshare/"example", testpath
    output = shell_output("#{bin}/vcfanno -lua example/custom.lua example/conf.toml example/query.vcf.gz")
    assert_match version.to_s, output
    assert_match "fileformat=VCF", output
  end
end
