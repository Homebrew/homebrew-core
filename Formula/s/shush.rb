class Shush < Formula
  desc "Encrypt and decrypt secrets using the AWS Key Management Service"
  homepage "https://github.com/realestate-com-au/shush"
  url "https://github.com/realestate-com-au/shush/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "b759401d94b2ebcc4a5561e28e1c533f3bd19aaa75eb0a48efc53c71f864e11b"
  license "MIT"
  head "https://github.com/realestate-com-au/shush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2abec620d598ba0b7655e71007dc4e0bd77c7ecf89f540c85c7cce5b9594a766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4eddd05ead07c7e5aba121ce9f52d9ebde508f13582e309b2cc94f9e7594775"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "235bbae46feb07e98354987aa2b7139dc0124af9f6420bd8427218468239649f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d895bc3945dc850cbabfed017e8fe0bdaad6ac2db22e0eef6b61e28dac59a45"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d4aa70631bb78c9080f8a8e459318d832e1fdac632be672beddc5bd3d9e40e2"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3d5f78a927f8694bd6e64e286129991d8984302c75411275b0909f8215d839"
    sha256 cellar: :any_skip_relocation, monterey:       "b889d1067edc8deb05de429b3847505421c19e715243295dd7653a282cb0d61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "949283b0dcf3f30c9838df02fef553efad86906bb540b0ff601bc0a07b10e2a1"
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
