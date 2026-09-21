class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v6.10.0.tar.gz"
  sha256 "8c357ab9b67b7e0ca57d1744c784e33770480f5c0336e0462d1281a7b71c3067"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b68e537a978ba8700e6b1aae69928379f54f29ec057a4a815aab8b3127c96c9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7c4240e22b9532995c81b07b5e2b3c850e4e8261c2f12a951fa99294e0a7656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aae850f9c1df9e9f83c8238859e047404abd7816af2a252968869902d2cc7ad6"
    sha256 cellar: :any,                 arm64_linux:       "b1211e2320c9e6b43e322b5e295ad8f51784598cb49fc65602a5112b27adea7c"
    sha256 cellar: :any,                 x86_64_linux:      "c730a531fb95a6a413fc10a3282632e526c752d234012f7e62a387e040e8d0ee"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
