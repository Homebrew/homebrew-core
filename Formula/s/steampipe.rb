class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "7582e6f944f0587e84acf4ba4acf31295bf6bf2f99d06a141f08170313c198e4"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d7c2bfb4286f496e9d37f625a1f0645214d0a125b77a7b0e9ce0bfe4a11f267"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7f8bd74b6ecfe3b5fe0267035c4b47ce7a9e4dfe46500e2d7e36c74be0a34c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50794814c421c682202d0e6713415f0eaaafbaa27a13cefccd7369eaffd38521"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c9d65a33f490f5451f6ca9d71559ff360464ca95c3cb1271e71d8b765f26a16"
    sha256 cellar: :any_skip_relocation, ventura:        "ff4c01d737827956c4d558c58cb9ca8df4cb19d99819381ea4d1a48f771ffccf"
    sha256 cellar: :any_skip_relocation, monterey:       "f7e862861639c63a7799c44bd32cddb74ede676adc9535be14976bc5a795dc4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbfe695c9e9bf88ff8dbd82c4526cf2eac6cec1bcba970b3b8cd40857e8a06bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
