class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.13.4.tar.gz"
  sha256 "778766769b9c7845b6f24cb25c940f675c8634b3ba58bf1c552c717a12fe0ead"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a076d8eb261a0e155f3831f12e3fa9c20d2fb55f21956511bd8709e76069c217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "486b86d4e32bfe9bc328228770cebbeff554e13f4c47c51507611abca172ecb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3024bb99bc151548d81b9209827098f69ac8ac4443df3cb8826c964ad6e1ccb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c2a28bf3f26aff4691d7ff96174ff0d2d61c31e657789fb0ebe7c98d56b1ad"
    sha256 cellar: :any_skip_relocation, ventura:       "7da2e134ada2cc0b4b0d0bcc3169553c29969b3c7de82e2ae020383271489c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b732ae9590d4d030261cb94737cb2e7db15dc6fce6bf7eee9a41ea0cd5c960"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"srgn", "--completions")
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
