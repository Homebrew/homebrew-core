class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.11.tar.gz"
  sha256 "078d8ea282572f08d9b3beb1bc24d3f6609a35ed8f316532ae71c19f7036d639"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c263c8837fed0fdd7c512735d9dc2a37f215d092160a73c09b60de77267145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c263c8837fed0fdd7c512735d9dc2a37f215d092160a73c09b60de77267145"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1c263c8837fed0fdd7c512735d9dc2a37f215d092160a73c09b60de77267145"
    sha256 cellar: :any_skip_relocation, sonoma:        "a70fed35aae3b3ee92f725122f714d2fdc36b313f5c877f0fcd93a169ce4450f"
    sha256 cellar: :any_skip_relocation, ventura:       "a70fed35aae3b3ee92f725122f714d2fdc36b313f5c877f0fcd93a169ce4450f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84057a1a43a42e015f5347ea1329bca183851b21e5d3ef6c0ccc9a41185d5430"
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
