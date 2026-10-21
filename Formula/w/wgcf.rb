class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "993b39e3085c9b53556af0e8297859c36ef1a5aeebf51378dabde49479ec1b7d"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54f47568f26fa2c43b9b3853adba6b1ef1b9be846a5a365b9051e6a42a7c82ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54f47568f26fa2c43b9b3853adba6b1ef1b9be846a5a365b9051e6a42a7c82ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54f47568f26fa2c43b9b3853adba6b1ef1b9be846a5a365b9051e6a42a7c82ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9efcb3adfe11f89422fea6d4e0a8478f2da5eb347a0eb84f21ccf6d901297f5"
    sha256 cellar: :any,                 x86_64_linux:      "9e60d67323de335b376b60671707e1de68578b97916f7d25e13ce455fcd63722"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"wgcf", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wgcf", "trace"
  end
end
