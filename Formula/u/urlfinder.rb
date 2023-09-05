class Urlfinder < Formula
  desc "Extracting URLs and subdomains from JS files on a website"
  homepage "https://github.com/pingc0y/URLFinder"
  url "https://github.com/pingc0y/URLFinder/archive/refs/tags/2023.9.2.tar.gz"
  sha256 "ffc5c2a92f3f43a2e135903a5a2d3ac2c3f7e21a9e4bcf0913f59687b1ccfdcc"
  license "MIT"
  head "https://github.com/pingc0y/URLFinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb7017df1768bbc97f4603e4d6dd9927c0d500b77f947a3e5ec9d0f8706d0749"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b1966e6142fe82853321c78bc7a13ac776f05b62c848028a18348a4899992c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a67be3b9a7dedc090d658252d0940c8cb2412af8e8fe8e87038f424532a04f8"
    sha256 cellar: :any_skip_relocation, ventura:        "93c9fd8b4abf61d885182cf4e623860a97407605d182959c187a8c34f46019f5"
    sha256 cellar: :any_skip_relocation, monterey:       "cea0962e9c2ad0880a7be08d77ba7c3e279052f28e53b3ccbfdf4fff9b47fe91"
    sha256 cellar: :any_skip_relocation, big_sur:        "009e3be83b8fcae2e6f9995e613fcadc875d0cc9261ceda52bd111d337b19089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2187cf29f2e379bf8d54ea5f86ba4822f32e6ba2004768ea7f07e2cd45616d3e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Start 1 Spider...", shell_output("#{bin}/urlfinder -u https://example.com")
    assert_match version.to_s, shell_output("#{bin}/urlfinder version")
  end
end
