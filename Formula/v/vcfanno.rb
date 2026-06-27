class Vcfanno < Formula
  desc "Annotate a VCF with other VCFs/BEDs/tabixed files"
  homepage "https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0973-5"
  url "https://github.com/brentp/vcfanno/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "a5119f39a70a3872067e00be2f20ac69ec8c2688fc9f4cf603b3de12c90cba4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92ecbff32912d88fe4b60fac125195702db65a0a439d9851d9345f291216aed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ecbff32912d88fe4b60fac125195702db65a0a439d9851d9345f291216aed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92ecbff32912d88fe4b60fac125195702db65a0a439d9851d9345f291216aed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3101f95a09f8e9ec483e97c8845e960873c19be0154ea2c2c95dc6608e19d47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68741a8fd0fd105b58eb3622ca6020ec586a46fbe8dccc5e16b2b05d9d0e1439"
    sha256 cellar: :any,                 x86_64_linux:  "99d5735c73a80171cc9e4763542be0bd5c8724717dce86491d903152e1bf7348"
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
