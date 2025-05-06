class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.26.tar.gz"
  sha256 "386e8ec5985d86ab25588070a737f761a6687127162dcc990370bf77eb108c1d"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a18a9be7728fa9991d8660ebbde60480eac1581745ccd2ef138fc3adec3e222d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a18a9be7728fa9991d8660ebbde60480eac1581745ccd2ef138fc3adec3e222d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a18a9be7728fa9991d8660ebbde60480eac1581745ccd2ef138fc3adec3e222d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c69cf8f52b21d05a02018760e7e70a6ec447b65329597abf6f50134c9da90491"
    sha256 cellar: :any_skip_relocation, ventura:       "c69cf8f52b21d05a02018760e7e70a6ec447b65329597abf6f50134c9da90491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff3bea8aef5fd2cc1e8b75d55e08e6c047bacd4c21e44c18ade6f0bc94e4565"
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
