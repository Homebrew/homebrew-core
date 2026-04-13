class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "d4f87fe88b314d66977ccb97482cb0acf960e8bd0936f98ab0036cb24f964115"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b796a177da5e0edfb6463b91e635865d8e7e29e0a000c7a6944b427efc477b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b796a177da5e0edfb6463b91e635865d8e7e29e0a000c7a6944b427efc477b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b796a177da5e0edfb6463b91e635865d8e7e29e0a000c7a6944b427efc477b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2cba4519ff3e0524c27920dbc754716dde340978c0fe330dce28571ede4b59a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6794033542974fd890e4f107e905212cd57394f6568739b1971917d1b2534c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca95a3cb1558a401f94f82b6aeb52371cbc953d9ea9f7e399cae38f4d55b3ec2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
