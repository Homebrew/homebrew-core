class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.3.0.tar.gz"
  sha256 "5c4c0022888b8a6c4d9042bc6ed3acf68e2b5dbf063094a3740f1e0e0bb2a9f8"
  license "MIT"
  head "https://github.com/vapor/toolbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "573abfa16ea3abd3ad51387c8ac7da964558ad07b1f4ac6df8790036fb715fbd" => :big_sur
    sha256 "f49f6f3ec03a5d17c155c4ea7bb72eecd766c669c32fec89bbd5bb1c65d84226" => :catalina
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
