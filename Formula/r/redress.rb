class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.39.tar.gz"
  sha256 "4469c13058d2bb521993adbe8b249c20e0992e6c62df6c77a4475416442e7977"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "febc5452a736522c1cbec7f19f1a5b389a6b355654b79f1d7ad65e82c41413f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "febc5452a736522c1cbec7f19f1a5b389a6b355654b79f1d7ad65e82c41413f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "febc5452a736522c1cbec7f19f1a5b389a6b355654b79f1d7ad65e82c41413f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f60c6ce35c4bf5a1e33d7e857867514411c8af318d66599273221853e96fc7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2cf32b5e965405d2b18487c9aa4d7d542cc8a56e2667a0e3f83b533ded9fc7b"
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

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end
