class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/2.1.5.tar.gz"
  sha256 "8878d73af523281441e6ec708998bf8aea1a5b22bf0a8822abd72067bd6566a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca99f99d0f0ca2952d2ac557b4d51582bcb243f09928b2d5dd0be6eb8e4282f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca99f99d0f0ca2952d2ac557b4d51582bcb243f09928b2d5dd0be6eb8e4282f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca99f99d0f0ca2952d2ac557b4d51582bcb243f09928b2d5dd0be6eb8e4282f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "48e81a78f08b8edd896366364455ea07235c755c8859c2e97731a66a498b14fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7693e8363687cb2fdd94f773632400a71779cee347eea90ec0638d1116c478d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b757f84ba81c25d8a257c77cd43b2df9961e7f60afaab3a1796787da68c2301f"
  end

  depends_on "go" => :build

  conflicts_with "trzsz-ssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output_v = shell_output("#{bin}/tssh -v")
    assert_match "version #{version}", output_v
    output_e = shell_output("#{bin}/tssh -e")
    assert_match "TSSH_HOME", output_e
  end
end
