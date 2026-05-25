class Vizb < Formula
  desc "Transform Go, Rust, and JS benchmark output into interactive 4D visualizations"
  homepage "https://vizb.goptics.org/"
  url "https://github.com/goptics/vizb/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "d378286151bf4f7612ac4a1017178852d4aff0d19ede7def36fd04b26d3f44ca"
  license "MIT"
  head "https://github.com/goptics/vizb.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/vizb --help")
  end
end
