class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "dcf540314faee0bf551928e1b6c02cfdd4fa98a0e51d030f308a110a24a48ed9"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5da527e1a6e4bb8b7f9b79799312c08a1851c1090c34198b9419ee00e402a59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5da527e1a6e4bb8b7f9b79799312c08a1851c1090c34198b9419ee00e402a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5da527e1a6e4bb8b7f9b79799312c08a1851c1090c34198b9419ee00e402a59"
    sha256 cellar: :any_skip_relocation, sonoma:        "50de2910152b0055f4e60acb0a131d4ba1d6f9cfd8c6fc01fe3ec12ff8a6aaf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b00fcf7d658b762f43a5566355864fb9ca076e5925c2e260c8ff030d867d2169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b55c3ddda370d75aa6e1cdee019b80de44884548c0476eb1d99ccc53722389"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"s")

    generate_completions_from_executable(bin/"s", "--completion")
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
