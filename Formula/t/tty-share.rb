class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "90e566cd4c064a1c0b31a418c149a1766f158dd01b3563e7501c98dafd8c244f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e87f8954b2993e8860aa4b43c5cae23846f054a4a88c7b5a00d55e978e0ac17b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a7c784ad44fcdd0d90dc72c0f755ced57104118bd40a592616598054ee748e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbcd192686b309a7ac1464e8d5ad9f08629b7111a1d6df176d0035f8f96c9bb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7466e5d42ceb6f8e44a88277a35a3da363fc4c045bdf5387356cd57be25be60"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1222c47ac0d476f00a0c64a9993038e7aa1409295793670c3ee3493d00943d8"
    sha256 cellar: :any_skip_relocation, ventura:        "e93c0812427d8ca2598bed21d0edf709f81c480b5a847a4a83ce20697d129436"
    sha256 cellar: :any_skip_relocation, monterey:       "a026b1cc81ea6aabcbdaa66d4b1dec583346db66cefe5d2c69828aada3b37f93"
    sha256 cellar: :any_skip_relocation, big_sur:        "c443d3f7c93183efb992b8ea9eae1998228d9a2193d70c217a1c5840c9487be0"
    sha256 cellar: :any_skip_relocation, catalina:       "0e202c44071ec49a25c615c91e4ea5ed41924b74a092dd7a911a0004ef953397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c88800f33577a7a9ef4e603a809a1c2355b9a3476a34d3f4cd7d98daf693dc0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "-mod=vendor"
  end

  test do
    # Running `echo 1 | tty-share` ensures that the tty-share command doesn't have a tty at stdin,
    # no matter the environment where the test runs in.
    output_when_notty = `echo 1 | #{bin}/tty-share`
    assert_equal output_when_notty, "Input not a tty\n"
  end
end
