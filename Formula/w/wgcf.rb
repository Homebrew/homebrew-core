class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.27.tar.gz"
  sha256 "45a426397ac15ba2f813744bce27d6fd0b4d400413197bd96b3d6ac18c8fc0e6"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8469173b73ea74188861edef5cd3b567d4908723dd5f9941dad3a21f4f63cbb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8469173b73ea74188861edef5cd3b567d4908723dd5f9941dad3a21f4f63cbb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8469173b73ea74188861edef5cd3b567d4908723dd5f9941dad3a21f4f63cbb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce777143152a4f7bdda7ad82ad23b4d6387f95a8d8f807e595c55be54466dd40"
    sha256 cellar: :any_skip_relocation, ventura:       "ce777143152a4f7bdda7ad82ad23b4d6387f95a8d8f807e595c55be54466dd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd5b479b166442a4a33ec1d0aab3b80324c75f35b1d9f2d4e1c6f5924dcdc8a"
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
