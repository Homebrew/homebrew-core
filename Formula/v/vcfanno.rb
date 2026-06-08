class Vcfanno < Formula
  desc "Annotate a VCF with other VCFs/BEDs/tabixed files"
  homepage "https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0973-5"
  url "https://github.com/brentp/vcfanno/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "f70b2dfcc9183bd984545144ba0d99b9cf9a837e49ba981b7cdb2085a617789f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29c909e614e5a767766f43b76608bf766f482905a919c43f69102d03997b0e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29c909e614e5a767766f43b76608bf766f482905a919c43f69102d03997b0e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29c909e614e5a767766f43b76608bf766f482905a919c43f69102d03997b0e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bb2e06c97b02e96b5e850ee7ee89b1d60a874dabb18f9093bed3ffefe7c4c29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0999dffcc6f95492b65caa0adfa9eb8e91300c080900644d41e58bd02d03e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b91271b2887d670d2d71511bca43fcdb90415f2338fece6cfc94b9b87bd21a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "example"
  end

  test do
    cp_r pkgshare/"example", testpath
    output = shell_output("#{bin}/vcfanno -lua example/custom.lua example/conf.toml example/query.vcf.gz")
    assert_match version.to_s, output
    assert_match "fileformat=VCF", output
  end
end
