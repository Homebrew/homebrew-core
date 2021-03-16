class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.3.2.tar.gz"
  sha256 "02bc54312705a09fa37fc429c1bb08a59b6fdbf01ce2380740e3bdc1994a7405"
  license "MIT"
  head "https://github.com/vapor/toolbox.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd4aea6ebc48a69adc44a5c203fa99a3f2407773b01103ebc97e39c94a337c3d"
    sha256 cellar: :any_skip_relocation, big_sur:       "48f27984e8ff7eb6a16574782bb96c18aefe60690d63a2cd4c39239d6a13c8bb"
    sha256 cellar: :any_skip_relocation, catalina:      "3e17e3a8020ea64789f6c2ec1eead0b04d9357390d9004a285af26f565828a40"
  end

  depends_on xcode: "11.4"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", \
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system "vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
