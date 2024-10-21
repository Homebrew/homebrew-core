class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "b74b001035637c4e7058845005ee16a86421355baf9ee38d466dea8fd8aa0a02"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c17f9a51c97ffa7c2ba98289d6856c4911cd0abe11104e9502f7a96f61ce543d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "757d8920d399087d800b62fee38ea790a1f99591dbdefdb0cba06d88359726da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bab9dc71ed8010347cc2d3fc89d51bee010ac886f82c295d49c50a464e710da6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f2d547b0aab8014bea1e07842f08801ca0aa9745d186f77f47fdcb8ed768204"
    sha256 cellar: :any_skip_relocation, ventura:       "169e007b7afe649f113ebf0d4d675247f2fb9195e4df7e139a61fd2d88974a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bbdbea5e0a5115eb23ac4488c46df15ec7ea0b78f6287ee25bc9596ec4536e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
