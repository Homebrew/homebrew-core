class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "1ec54018b71af38c111dfe0d476a1be59235518afa26f591ac070afe093eb4fd"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ef83d40522a657fb9a56b4b9b8d1a4ba7e44e58ca54d00d85dd0fb56e4e9dcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f76b5f9df7e13cb1d8e8c2b3e85a274a9f852249ff397ea5f67de7ecb041ac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b04896ca9e495fc60dea6c26c2d853ceccd6857c2b15544faa4ecbb6f4221ee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "edf3e5acd6b47237b4613ff2f9b502a778b07c16104696384b94a83e83a3f2bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58e59ba01bd85245ee839a914dd9686d92888bf3917a933da5b09c7635ac20e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48c3f53b58a823a2163fd8fb2aaa00df031a0ad47dfafa9c5b0e725cde9f576"
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
