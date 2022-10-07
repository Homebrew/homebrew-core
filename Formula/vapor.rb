class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.6.0.tar.gz"
  sha256 "fa41a5ef847fcb86ce9f2a9837adc9d80ba99839519d230115f2b00ff7a64156"
  license "MIT"
  revision 1
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04c7eeb2a71e7e4fc2da6e41aa9d04943373aa62cb9a96d4501a9e95a2690f07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bd0dd23b86527ee620a13e401925d0b18de813ac8eb76dbe050e3b3ae354ff3"
    sha256 cellar: :any_skip_relocation, monterey:       "4287b44b44519eeb45ca9e0bfaa6c12e184ffc9b3cd2296a373d8ac6cf38337f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcd5983c3d88508b0de84083f3d6865cc92e8413f5c9b63ba5a9ae5561a9444d"
    sha256                               x86_64_linux:   "5bf987050ac211251bf1f4e965b8a29e29ff3084523010006ad0d9f308ea55b7"
  end

  depends_on xcode: "11.4"

  uses_from_macos "swift", since: :big_sur

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
