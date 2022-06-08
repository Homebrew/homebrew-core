class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.5.0.tar.gz"
  sha256 "70be40f3ddd6c8fe238ac340655daf2f7e545cc406a1d6684f474cfaa17fdddb"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c45f6c189831f339694506406b6716d6d6b63303d27c89b5d237a5dfc344cd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b70ae397fbe4c87e4e5cc404393cd0cf6d10d8b4ff8bac578cc7cddcc893673"
    sha256 cellar: :any_skip_relocation, monterey:       "9551505865840cf27bc732632b9bbddfa96898baeef9c2ddf3e0178bec3cc203"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9135c9f2904d15196cbb726b070fff83d7b8796da1b7334bf2401f47c8c20f3"
    sha256 cellar: :any_skip_relocation, catalina:       "dec39f0259abb6a8203172cae7f7bb79f0d3db106cf53d5210d79fabe4cd5894"
    sha256                               x86_64_linux:   "ffc52ce11835b32fb16e009c246cc20ab5d1d576bf136339609ac0f02a155ca1"
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
