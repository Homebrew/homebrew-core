class Threemux < Formula
  desc "Terminal multiplexer inspired by i3"
  homepage "https://github.com/aaronjanse/3mux"
  url "https://github.com/aaronjanse/3mux/archive/v1.1.0.tar.gz"
  sha256 "0f4dae181914c73eaa91bdb21ee0875f21b5da64c7c9d478f6d52a2d0aa2c0ea"
  license "MIT"
  head "https://github.com/aaronjanse/3mux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "471a6870e6b9d45e994d2977c855e0aea4ed22b1f59f0d09afaf4d096edd0e2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d3dd3465938d0ac5b845b07689a08b667613210d9d58649c9a152ade32dc347"
    sha256 cellar: :any_skip_relocation, monterey:       "64497230017e4e033cbafc7ae8f684e5ff77c1a8af3ec153f715269d5f4dab01"
    sha256 cellar: :any_skip_relocation, big_sur:        "c87ed9904dccc4872aa6c8ed0e6de39bc7f3ccdb5fa7fef1b99e45871d85da18"
    sha256 cellar: :any_skip_relocation, catalina:       "8071788129cb66bd2e7c6fe9f877a56fe2807b70204747a858a4e68a650a07b8"
    sha256 cellar: :any_skip_relocation, mojave:         "d8ee02f2139e26800e6fa830e02a09b52df74164ec3cdf2306bf89c4ef6b92f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33200f3fd9175837129386fdfa67575eebacc806d9da099d98b0888aaff56124"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"3mux"
  end

  test do
    require "open3"

    Open3.popen2e(bin/"3mux") do |stdin, _, _|
      stdin.write "brew\n"
      stdin.write "3mux detach\n"
    end

    assert_match "Sessions:", pipe_output("#{bin}/3mux ls")
  end
end
