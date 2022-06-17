class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.5.1.tar.gz"
  sha256 "65c0d8ccf17fcce050110de1706fd345b00ad74267b0f5945d4345e04fc11672"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a597647b1d2ea5a2d93a3c3bc6e2ea712934742bc7edb13eca1974a5e5a9882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2acb3bf8b7d15b0933afa89ca60a7425105eebaf74cf43022649a7031b219da"
    sha256 cellar: :any_skip_relocation, monterey:       "cb34deecc5f3b363eb852cc9c362007343c041435db6825c3b3d936c0b6fc824"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bbfd3cd885e0723bacf848b55dd2cb98e8c706bf0a1287463d19ea47e7a304b"
    sha256                               x86_64_linux:   "b72618849d01ac80902ae0443c0c831fe129c57f60fb55cf129d293822f9bebc"
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
