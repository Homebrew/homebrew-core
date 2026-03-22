class Wishlist < Formula
  desc "Single entrypoint for multiple SSH endpoints"
  homepage "https://github.com/charmbracelet/wishlist"
  url "https://github.com/charmbracelet/wishlist/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "ba1a9bbd1925e2793d5eb97e38351faf5f9efdc89921af1f1322d9b88b94bdba"
  license "MIT"
  head "https://github.com/charmbracelet/wishlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d701b7e532275ccddcde513950176e79743e50a2e4c602b24848d573418308d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e77986d045c2b98710bb331b52d217aa06b058d71a6708ebdda71032633beff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e77986d045c2b98710bb331b52d217aa06b058d71a6708ebdda71032633beff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e77986d045c2b98710bb331b52d217aa06b058d71a6708ebdda71032633beff"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ac28340cfa526431d73fa37c72eeef3c8da7847ae85034edfbd9f6686728ff9"
    sha256 cellar: :any_skip_relocation, ventura:       "6ac28340cfa526431d73fa37c72eeef3c8da7847ae85034edfbd9f6686728ff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a07f7dc954c52c5eb7728c4e32e223cc23bb6756ad7b60fe9ec314e105830037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb48dabd9a636100ec378e63bbda9ad471a14b742f323556143db04942fe2f04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/wishlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wishlist --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"wishlist", "serve", [:out, :err] => output_log.to_s
    sleep 1
    begin
      assert_match "Starting SSH server", output_log.read
      assert_path_exists testpath/".wishlist"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
