class Spacectl < Formula
  desc "Programmatic access to Spacelift GraphQL API"
  homepage "https://spacelift.io/"
  url "https://github.com/spacelift-io/spacectl/archive/v0.7.1.tar.gz"
  sha256 "49338280575c8a1309e6b6b0870279f28fa6cf3940f602376a645ab879e99e21"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spacectl version")
    assert_match(
      "could not find a profile named 'zzzz-homebrew-test'",
       shell_output("#{bin}/spacectl profile select zzzz-homebrew-test 2>&1", 1),
    )
  end
end
