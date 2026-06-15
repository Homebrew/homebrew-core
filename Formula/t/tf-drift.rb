class TfDrift < Formula
  desc "Go utility to detect, filter, and inspect configuration drift"
  homepage "https://github.com/brunobrise/tf-drift"
  url "https://github.com/brunobrise/tf-drift/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3ee91c29f22210c577554b64562d8251e8ac9ee65656064560a1a6261507b1c1"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tf-drift"
  end

  test do
    assert_match "tf-drift v#{version}", shell_output("#{bin}/tf-drift -version")
  end
end
