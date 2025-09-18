class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "ab907adb5941ce1ffd1effaa63e5ec590203b6e8dee072e4143591fb2650fa95"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa8db9c8b0e6f3fd29fb56c275b1a0a68a18a77b7396283d0233e5bdea58998d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9bc742a1e48ae6b069079ce795d6e4b50d534cc8f81aee2993e2091b81087ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ccfd7eca55696103134e88fdddef68f2aabb3e56ec173a1227522bc57fe3b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "beaaed9f8ef9e9e85d61ef726daa961962d73563e83b4001e9d8fc70cfdb7c4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6daddb02750debeb5b80b70ec08bcb31e8f2fe75766e29db978000164b6fd948"
    sha256 cellar: :any_skip_relocation, ventura:       "85c510d6bc27b85281a7b35f8e2326cd9825af9ab3833ea822138d4631bc915c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7700cd36bee38b2b760caa1f896aa0bc40061a8932deb58fdd8db250e2b73a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9869e55b20fef1e24b4389cf06433f0256fe550b7429daa3d01f0b2f3aeef822"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
