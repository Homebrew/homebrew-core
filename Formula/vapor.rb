class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.3.0.tar.gz"
  sha256 "5c4c0022888b8a6c4d9042bc6ed3acf68e2b5dbf063094a3740f1e0e0bb2a9f8"
  license "MIT"
  head "https://github.com/vapor/toolbox.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12d126585948d2dc22e167f4205f19920078dbb904353e597d5b4f41d91bc88e"
    sha256 cellar: :any_skip_relocation, big_sur:       "da3193953c1f566f05588685fb43ca1062cb1a568d8ca49da78e934b7e8c9dc8"
    sha256 cellar: :any_skip_relocation, catalina:      "838b76a8bb22a478d5de45054c7867e5bda1dc725d315edbc40b63523bfadc6f"
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
