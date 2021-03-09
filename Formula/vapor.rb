class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.3.1.tar.gz"
  sha256 "82243069b54ad280fc02204554d8f3dc41afd74c2ad98eb633ff9248d09bc00a"
  license "MIT"
  head "https://github.com/vapor/toolbox.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fa4ef9390d0d07445aa299db3e27b7c4a278c40261ad25bdc6bdce41b43d44e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a90bf17013c0a14265579cf25c9b3eb1639a4b7493ed1828760281fcc208efb"
    sha256 cellar: :any_skip_relocation, catalina:      "4a865f0938fec6da6bd461b1bdbbdb70b15a7e01371ac5ac1b41f862a481bf4b"
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
