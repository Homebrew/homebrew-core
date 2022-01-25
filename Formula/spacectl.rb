class Spacectl < Formula
  desc "Spacelift client and CLI"
  homepage "https://github.com/spacelift-io/spacectl"
  url "https://github.com/spacelift-io/spacectl/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "49338280575c8a1309e6b6b0870279f28fa6cf3940f602376a645ab879e99e21"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "true"
  end
end
