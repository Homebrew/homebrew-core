class S3scanner < Formula
  desc "Scan for misconfigured S3 buckets across S3-compatible APIs!"
  homepage "https://github.com/sa7mon/S3Scanner"
  url "https://github.com/sa7mon/S3Scanner/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "a3bd4d4a224266723ee4002e252fd0a543a8f0b7ceb167d2126b4da30ded81ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1462135a4437ad39b1bb2b50d93a5c39db643f88a960e7e9af7b06cd34a194a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3bfa121b90ddac8bdb8584a0624d02b96e19f48df759e94be62365b7d818d39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c57e3ddba57070fdcc0ce7bbb9176cafa62c0e7e3dde6beff24c08f1d12505c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f44fd1937d5244aaafc94889946704e68fbcf8d2da27cea770292d290d2ad32"
    sha256 cellar: :any_skip_relocation, ventura:        "26fda5ad547ce85b5bffb6ca5c47e7ed12908ed1f58c48739a927cda0185a442"
    sha256 cellar: :any_skip_relocation, monterey:       "10c6628b566eb910fe07df427cdb62fe037f3e1772211b1f18af7cba502c8191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441f30f307e215d3ac9075b52be70bd2d4ca7a014cb63cf7465b1037a9877445"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    version_output = shell_output("#{bin}/s3scanner --version")
    assert_match version.to_s, version_output

    # test that scanning our private bucket returns:
    #  - bucket exists
    #  - bucket does not allow anonymous user access
    private_output = shell_output("#{bin}/s3scanner -bucket s3scanner-private")
    assert_includes private_output, "exists"
    assert_includes private_output, "AuthUsers: [] | AllUsers: []"
  end
end
