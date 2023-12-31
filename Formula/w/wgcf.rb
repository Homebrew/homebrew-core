class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.20.tar.gz"
  sha256 "b8f94263ef1adb8d7bc3f84cc7cd5403404333673aaf1896a76601621f317982"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "089a5eb532802ef522ec0eda2c9ff1bbbb8f63d5349fb89bd67fb6d2622e6bc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98158efd3dda9ac2015fb08017c4be5cf1f0fafaf48f8019fa5ba27a3d4809d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d23d87fba3aaa5da28c6790308c718d63c5bae738c5ae65ef7a0edc7631e49f"
    sha256 cellar: :any_skip_relocation, sonoma:         "55c42dc3912d043c879634fbda9a53e14a63c6e2f84137838cfb4e6affbea460"
    sha256 cellar: :any_skip_relocation, ventura:        "6df2f96b8593ec5b28f8615d7c56277d8bd5b97822ccd26cae567065752cd6e5"
    sha256 cellar: :any_skip_relocation, monterey:       "71bf101fbdb1acc44b32ff438735b68410df33bc076743be2ab66bab06e3038d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d877747de1a040d65b15d3ba46c565f525ea32bc4daa40c1dfd318029fc6bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
