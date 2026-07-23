class Shush < Formula
  desc "Encrypt and decrypt secrets using the AWS Key Management Service"
  homepage "https://github.com/realestate-com-au/shush"
  url "https://github.com/realestate-com-au/shush/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "b759401d94b2ebcc4a5561e28e1c533f3bd19aaa75eb0a48efc53c71f864e11b"
  license "MIT"
  head "https://github.com/realestate-com-au/shush.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb7a0c98b5ea7620cc88ee17ad45fcb0897fec6752592c0ce4c177602e3f3700"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38e8b3daac478d4f716b340df549741e7bd46d2fead43762a20e896357f73697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38e8b3daac478d4f716b340df549741e7bd46d2fead43762a20e896357f73697"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38e8b3daac478d4f716b340df549741e7bd46d2fead43762a20e896357f73697"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f4578b270925b1861d476ea6e55e5aed44e3d690f27c9a2118e2079f3ed1fc7"
    sha256 cellar: :any_skip_relocation, ventura:       "2f4578b270925b1861d476ea6e55e5aed44e3d690f27c9a2118e2079f3ed1fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee89a1978ca2de39602e1e0b0bdd7b66b01a428af95621dc9b6c7b2f66297753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dd8b6893291ab04f6aab2a7928e694cef9601feddc6b7bf4f59b1f54df023a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/shush encrypt brewtest 2>&1", 64)
    assert_match "ERROR: please specify region (--region or $AWS_DEFAULT_REGION)", output

    assert_match version.to_s, shell_output("#{bin}/shush --version")
  end
end
