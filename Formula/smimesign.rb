class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/v0.1.2.tar.gz"
  sha256 "890b85bd5300dc2b2d4ba7e450d51c103ccb17923a937f06a58673cbedf93dd3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3f4c92352787070142ddd12f790f4804ed5ef2b76089625aa30fcfef97afcaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf7f62f82fe0ebb4e193398fac409ac543487e48d68a9f95c23149b5015960c4"
    sha256 cellar: :any_skip_relocation, catalina:      "2ed575699e487d4d428142f69504785e8cafb7d2bfc316f93481e7d6a4c9935c"
    sha256 cellar: :any_skip_relocation, mojave:        "91be725d12baa79d08e6cd67bed3528d22f5fe39ce1664001ab0a0c1ceff3093"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.versionString=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity",
      shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
