class RsAggregate < Formula
  desc "Aggregate IPv4 and/or IPv6 prefixes into their minimal representation."
  homepage "https://github.com/ktims/rs-aggregate"
  url "https://github.com/ktims/rs-aggregate/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "8c2bbf84d095d7351461fe482b62233801f24c0df1dcb25807db8553065193f2"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test case taken from here: https://horms.net/projects/aggregate/examples.shtml
    test_input = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/24
      10.1.1.0/24
      10.1.2.0/24
      10.1.2.0/25
      10.1.2.128/25
      10.1.3.0/25
    EOS

    expected_output = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/23
      10.1.2.0/24
      10.1.3.0/25
    EOS

    assert_equal expected_output, pipe_output("#{bin}/rs-aggregate", test_input), "Test Failed"
  end
end
