class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.2.1.tar.gz"
  sha256 "d2924fe58189cf8a2ded95d38a6cc05a29820450e26a5163802799cf45feeea3"
  license "MIT"
  head "https://github.com/vapor/toolbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b34e9ef3f43cfaa725a60798e6a32997233b56479b0889161dc8dcf026a86779" => :catalina
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
