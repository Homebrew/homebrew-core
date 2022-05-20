class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.4.1.tar.gz"
  sha256 "8109b21f45be3f73d9e823fd741341cf687c16ee0fae1eb1d30ada865eeb3efc"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9844f4021880ae9c897816e239ec7b8e2a4db84db38c901b23831aa475229066"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f2297e3b959aa4e8708c8319c6408057c0ef65b9804e249862a818c93433231"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d30a46e7df99f7da46e2aff3c9e8aa4e70f5d290295e81ff32f8b49be0819d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9f72599af6fc398847a947a80e8fef567e5c1d4ecf2ab9ecfa3161fb1c80187"
    sha256 cellar: :any_skip_relocation, catalina:       "19c812ee543c37232b4ede3bb38de34b92812fa3ffa6ac32962728a974fd9201"
    sha256                               x86_64_linux:   "7e9c0e6e4bedd6a176c73b01d3658677f052fe9db01e3b5feb3cb91e4e4dd4f8"
  end

  depends_on xcode: "11.4"

  uses_from_macos "swift"

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
