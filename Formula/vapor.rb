class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.5.0.tar.gz"
  sha256 "70be40f3ddd6c8fe238ac340655daf2f7e545cc406a1d6684f474cfaa17fdddb"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cbdbef47b8f1e4097aca79ce4141cff2e0cc3b0aee8d9c0f496796e41089e7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a01ac44c2f75fb540609934c330ba01936e8b4bcab4bbcda8e2521fb639cb5a8"
    sha256 cellar: :any_skip_relocation, monterey:       "ea361d8a3901b4c9ea7954c88187efd46857b350182cb6f0b14ff21a54b0a513"
    sha256 cellar: :any_skip_relocation, big_sur:        "f929de0d210d6cad1a8b948a18ffd547e22458e49c5a8e20a29488c793316573"
    sha256                               x86_64_linux:   "17f9b61d30e5e748d168838b587783b32ff2a5736790427075afa6645847c79f"
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
