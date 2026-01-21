class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "76936ff75beb3dfc8842acf4a7b1dd45637b0be5b37daa4d2c0d7dce147bcf0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4e2263a1f942b723a2198737238b903ddf5a340cdee91f9a85823a720579dc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2dc10548500aa904bd06be7ca15ca419bcf723e25a3cd42a2e6295569aca58b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0525e9149a1e00f58aa049ff7ad8dc009fa38aba90ed99b39f8ce67f6069f75"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ffa15130cf750b2add3bf9bea998e316b4eb1762eeebc66d8eca5afd410094a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c564a167ee65e0971f1e76ace15f0d2cdc52cf656a7296be67375833a89ee100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6fba234e82170095be2cb81af4274bfb906238c7493d0d2ac4a51907678fef1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end
