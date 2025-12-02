class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/refs/tags/20.0.0.tar.gz"
  sha256 "b3b215a69ae8b5235d4f37229313ee1947de5c5b9ad2142a76b17c105dd758cf"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad33e861b01620717b6a38a87ff83fe4b79e3447067be1eede4db6d2fa544bc0"
    sha256 cellar: :any,                 arm64_sequoia: "9db6e2d0f5e2c9d5dea8f930db379e2f8a899d5af09f402d29521074cb05afdd"
    sha256                               arm64_linux:   "b91ac9e335b8342682cf2032ea9a91336c870f01ebad067ce2bb1523ada305aa"
    sha256                               x86_64_linux:  "7d4caa94d7be2095ee335b2c954bea42d308e4f79aa641bf4d345671bb8445f1"
  end

  depends_on macos: :sequoia

  uses_from_macos "swift", since: :tahoe # Swift 6.1

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "-Xswiftc", "-cross-module-optimization"
    bin.install ".build/release/vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_path_exists testpath/"hello-world/Package.swift"
  end
end
