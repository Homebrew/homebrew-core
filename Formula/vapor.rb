class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.3.3.tar.gz"
  sha256 "07d4b6aa15aa25e16b3bd380c6d6e30013b83c92ceafd8ac58dece5d60a37d96"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef27c5d3d9afad7c3b8dbe07659a74a3a59b0c39f4ca027f4fe76e1c018dcde1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f974b1496e99550fc96dc8a7adf39ad0b1c056be4d6a1d0103513c685e240c4"
    sha256 cellar: :any_skip_relocation, catalina:      "8a7c9c84674db7f43939ce9d9cb328cf89d1c97027ee62a0973bcb52e2a1ab54"
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
