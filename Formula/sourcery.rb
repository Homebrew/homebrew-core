class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.8.1.tar.gz"
  sha256 "a60b920b9dc4d3b7dc38c9d3593391c399ae6c5966734bb6d6991b73d0959898"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df19b1c5f921b36473c9de0cae013e705a796b2e4d439ea9cc1b43a1df4199bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59234183803f8dc23797334a4f995a037e68ca51faf9f6242da18b0892f85f82"
    sha256 cellar: :any_skip_relocation, monterey:       "5d93cb5bf7a3adc4dba8ea972fb9347190cd04238efcd60942192c56c096cbb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "92cb87ac0c373bd0ad1111d388916c86f4fcdd390686143b2ddff85a664f1b7a"
  end

  depends_on :macos # Linux support is still a WIP: https://github.com/krzysztofzablocki/Sourcery/issues/306
  depends_on xcode: "13.0"

  uses_from_macos "ruby" => :build

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
