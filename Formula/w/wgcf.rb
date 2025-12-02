class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.29.tar.gz"
  sha256 "25bd436c3d0919c8e76a2e31806520c401c9561663946951746d4027a7fab96a"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba799c69141d00580e0b958f56c0a3af8b1dc8e0ce8951e40dd3bc634af35574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d96ee5fd4aa174e7b9359a066fd9debdfcd3a7f6a02530fe30d35a410d1530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d96ee5fd4aa174e7b9359a066fd9debdfcd3a7f6a02530fe30d35a410d1530"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2d96ee5fd4aa174e7b9359a066fd9debdfcd3a7f6a02530fe30d35a410d1530"
    sha256 cellar: :any_skip_relocation, sonoma:        "47628a8d27650cbb1bf170fe9483c572e720e92aaefd8c0eab5e5b73afa573b2"
    sha256 cellar: :any_skip_relocation, ventura:       "47628a8d27650cbb1bf170fe9483c572e720e92aaefd8c0eab5e5b73afa573b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d66b38508019bc88af75c9ae9080316ecbd6755b8bb7041eab3746774543abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c71ca47de68b992c0f2db9643994547cdaf63fa15810098257552cae6ee747e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system bin/"wgcf", "trace"
  end
end
