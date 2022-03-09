class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.3.6.tar.gz"
  sha256 "67efb2d454564be007e520afb582b9d1d3bf2ac93b49e3ecdec5495df724c2cf"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e0192858bca261ff3690cf1097896eaa5a9866a5d2d692410fdb7e8971238c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "617785d6e88b734dafb4e2bd0c4fbca219d28f8dbce88a14befe8a8405579d1b"
    sha256 cellar: :any_skip_relocation, monterey:       "7a6b32eb224796649a9e2024e7a430124bdebaf4253c42ca90a755aa3fe4690b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2488d72900dbcd7147ef0b1c756baea6c69c3a976a63cdfc4f7537764a244ef"
    sha256 cellar: :any_skip_relocation, catalina:       "0622f5ae31e2f4be566727425b0fce7cc8b5d79b60d80fb54a7abc9c86d51e1b"
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
