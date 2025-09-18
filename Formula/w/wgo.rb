class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.5.14.tar.gz"
  sha256 "68adfbd4e2b4e3ec8c4f61015cddfa2983be0b3975e6feecc00ddd6984c45235"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6990624fe3f87d1eff2f87d58fe7154fc8446a7ecd35ba56e2b0b0997ac693b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78157d813cf8873382ee72b9d2aa8d842e89746fd52921be2a6f6d0152deac13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78157d813cf8873382ee72b9d2aa8d842e89746fd52921be2a6f6d0152deac13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78157d813cf8873382ee72b9d2aa8d842e89746fd52921be2a6f6d0152deac13"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5a3c3e58b374ffbf760343e3f06e3ffa0eef05d5cce3805972af1ba6572150"
    sha256 cellar: :any_skip_relocation, ventura:       "2e5a3c3e58b374ffbf760343e3f06e3ffa0eef05d5cce3805972af1ba6572150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d274c4983c5d924d0b11f3b260b3a08ab63e012cceab9968d79a0b7197ba55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47f8b6a742e5e07968ce8f37c85e0888806cc1071d3db786aa0e73e763cb2bb"
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
