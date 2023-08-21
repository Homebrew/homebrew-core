class Shush < Formula
  desc "Encrypt and decrypt secrets using the AWS Key Management Service"
  homepage "https://github.com/realestate-com-au/shush"
  url "https://github.com/realestate-com-au/shush/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "9b4c4f24fbdee1e761e67984d85c51bcb656db7e3e03406200d40ade765417a7"
  license "MIT"
  head "https://github.com/realestate-com-au/shush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95d7c795431217ecbe5a637818006a421fe5af863114a79753d1255dfb872430"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95d7c795431217ecbe5a637818006a421fe5af863114a79753d1255dfb872430"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95d7c795431217ecbe5a637818006a421fe5af863114a79753d1255dfb872430"
    sha256 cellar: :any_skip_relocation, ventura:        "6381063d60b49716cb67d4c0daad0526e349efd58c84c99e7396b00458f46a47"
    sha256 cellar: :any_skip_relocation, monterey:       "6381063d60b49716cb67d4c0daad0526e349efd58c84c99e7396b00458f46a47"
    sha256 cellar: :any_skip_relocation, big_sur:        "6381063d60b49716cb67d4c0daad0526e349efd58c84c99e7396b00458f46a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd461e6fd682fb787771b7fbdf5b55ab7dfb8a24d2a027251dbc034c6381a1f5"
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
