class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.3.tar.gz"
  sha256 "f82a9bffcd2384ecf6e80e36b9f49364ef4b4b987ebd597d509eb15b43a9888b"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e486be015b41378371e086b9df7c7b734465556f21f6789bd33e2bdeb614606" => :catalina
    sha256 "e0928d19465a765bcea6ac6b9350989b6b6e900f415de2583e2380d9efbbc4a8" => :mojave
    sha256 "362b9547cfe52c9f26122eccd50ec2a1f00353c63e4e6be5eb8b67248ab01f35" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
