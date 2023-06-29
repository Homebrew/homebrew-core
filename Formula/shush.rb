class Shush < Formula
  desc "Encrypt and decrypt secrets using the AWS Key Management Service"
  homepage "https://github.com/realestate-com-au/shush"
  url "https://github.com/realestate-com-au/shush/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "07eed7f6fa34b0cadf64e5dfde752f12fa038293765eef35d43790c479e72fc6"
  license "MIT"
  head "https://github.com/realestate-com-au/shush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d35e69dcee48532071a02c70af5858b6d9297d4361d1a541501902ca0c51ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04d35e69dcee48532071a02c70af5858b6d9297d4361d1a541501902ca0c51ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04d35e69dcee48532071a02c70af5858b6d9297d4361d1a541501902ca0c51ca"
    sha256 cellar: :any_skip_relocation, ventura:        "2645da3c73c6c1feb774393d5660475f835f0d32c81077942b91e42d3cabb154"
    sha256 cellar: :any_skip_relocation, monterey:       "2645da3c73c6c1feb774393d5660475f835f0d32c81077942b91e42d3cabb154"
    sha256 cellar: :any_skip_relocation, big_sur:        "2645da3c73c6c1feb774393d5660475f835f0d32c81077942b91e42d3cabb154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105e00c20659fb62b2e0ca42914d109ab87beb7aca584a841c707fc6e86f25d6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/shush encrypt brewtest 2>&1", 64)
    assert_match "ERROR: please specify region (--region or $AWS_DEFAULT_REGION)", output

    assert_match version.to_s, shell_output("#{bin}/shush --version")
  end
end
