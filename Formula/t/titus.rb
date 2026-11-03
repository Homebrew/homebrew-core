class Titus < Formula
  desc "High-performance secrets scanner"
  homepage "https://github.com/praetorian-inc/titus"
  url "https://github.com/praetorian-inc/titus/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "00b22bc9896f36351259153989ef1a5d1061598e56dfb009097e5a5115742fd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d771130129b920f1bb6f348ebc967118c0030ade27d8b0c021f32a265179e268"
    sha256 cellar: :any, arm64_tahoe:       "2355122f540cccc2baf019e0e101c171de401af47ce78bdfb2f982d0ac5ec2ce"
    sha256 cellar: :any, arm64_sequoia:     "e83ddfea9f2fa8e6043652c14bb11994c82e62170adb07fd5573f69a34fd99a6"
    sha256 cellar: :any, arm64_linux:       "f4fdc982aa7e5e449586b5c158e07dcec96085e151edb328522a4c852fdd9055"
    sha256 cellar: :any, x86_64_linux:      "8370c278be8ad4fe58f28f386e4a4acd9a4bef9baf3afc28c3a76088649f61ff"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "vectorscan"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", tags: "vectorscan"), "./cmd/titus"
    generate_completions_from_executable(bin/"titus", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/titus version")

    output = shell_output("#{bin}/titus scan https://github.com/homebrew/.github 2>stderr")
    assert_match "0 new matches\n\nNo findings.", output
    assert_match %r{[1-9]\d*/[1-9]\d* rules compiled for Hyperscan}, File.read("stderr")

    require "utils/linkage"
    libhs = formula_opt_lib("vectorscan")/shared_library("libhs")
    assert Utils.binary_linked_to_library?(bin/"titus", libhs), "No linkage with vectorscan!"
  end
end
