class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "6a8e521b466b63b3c25d78b1e72662b548babe15423061c691c7039b2e0c03d4"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4583cfb6dd4be62e056384be34d0c9d81d98d000dc509ddce4dba20ecc437b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2306a0f553989c7ca68a7e4dc34431864aa10dc588c7e8f96545e3b54112de6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d3c46df92c593780b694cbb6e8a3ba041397f634022720c30db61fec95808b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d848d04a817ee76d2ebc9f2cc2706bbfb5d893a0f981ebfdad0ee64ea73765ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b78feaa7f8cd50b3d644338478b7de0ff45381805b4808bb47238f531eb7a117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50dd708f98356b11a75f6173d91cdc0c483a9299f719ec51ca9b3ec41b6918e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
