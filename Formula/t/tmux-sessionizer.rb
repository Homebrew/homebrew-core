class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "d33e0e7c544de0798ab9fdfdfd2914ee486a6bdf61f183f8634a7f42a1006ba0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "691a259dca94951fa001d0e5fac2f5ef8053967dfa558bf02d81254feb0dee01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d474957de8463c836bd1c915ad59667aaa203168490d431a46c9b996ab7f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3acdb075e3e4f05370452d5c7e355ab2667776d0ce059ecb71c515fd33bc8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "69b2ec1579e1baed3782b63ef6c3bb174f7afdc8b3fc713c954c1db0dc4a5b75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bb505e7eaa28699e5691efc1eb88e15b19bb7be6a17e0a277969a0cef87fbfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf6819b1996d90c69172a9460e81e3779de4b8a9daae77b2970a0b79c2977de"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tms", shell_parameter_format: :clap)
  end

  test do
    assert_match "Configuration has been stored", shell_output("#{bin}/tms config -p /dev/null")
    assert_match version.to_s, shell_output("#{bin}/tms --version")
  end
end
