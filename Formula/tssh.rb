class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/2.1.2.tar.gz"
  sha256 "1c6b00750260d2c567d99f8bfd0c7fc87a96ac0faa3cfc8d54cb32400e95bb56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f45fc530482f76d31be04fc447ad9ddf1db45542f845346d035738fe12bca04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "222ab84f9c686b2606c5424d5ba3183517ab606851d7d6f9131f8122b3f4047b"
    sha256 cellar: :any_skip_relocation, monterey:       "48d5b1f6af2a47e38deb9aae9d969607b250a574458b1825ca664b4ce689e2e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d19409fa804d5d474ac267f4bacc1a808a48c04a0d6f441a7e26b2e1c3c48f3b"
    sha256 cellar: :any_skip_relocation, catalina:       "ebf00c55633da328741f17335406fd7572ea8b1509182131b7d46878e9451ea8"
    sha256 cellar: :any_skip_relocation, mojave:         "518731cf99cf6194aa510453b50fbd1da16bd15c4eccfd0d8e8d6f35537ac669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "148c99f128411e59d6e67e73f70f1a5cf74ae7553afe9587dfdcc631bf38a2bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output_v = shell_output("#{bin}/tssh -v")
    assert_match "version #{version}", output_v
    output_e = shell_output("#{bin}/tssh -e")
    assert_match "TSSH_HOME", output_e
  end
end
