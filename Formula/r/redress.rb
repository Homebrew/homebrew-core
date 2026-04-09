class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.63.tar.gz"
  sha256 "3cc79c1d0403a6bfa682f601b7ddb118317c6cfe5d6b69fd218a5cdd5fef062c"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "497928f112958aa5629fbcfea3282efa99bddf727ce5f6903dc8b8d26e112144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b36e43ab6c7a6bd21cb13bfb9f93447009d574d7988a4ce513684ae097115e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c46aab9f47fcd5ef61549c23ccd7573d339b66952633f8eaf393617371a148a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "edb7d479dba047f50a7b354bc041befb09568ce28acd6fd975532ed7a20ed327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c5ef13850657fb9d8179fc4740603caaadc13b8b5396af373b814a68c62ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190d65a035844a0cf16a6b5389df0389e4a678f1f108ba11968237d3b1ad3db2"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end
