class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.3.6.tar.gz"
  sha256 "67efb2d454564be007e520afb582b9d1d3bf2ac93b49e3ecdec5495df724c2cf"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ef22d372a68994a9d5899fabaa4896308004c46669fa481a1bbdd6dc77580b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fbcfb559f75f91accf311034cd7dd38e8d075aa14cdac11136d81a4b339ece6"
    sha256 cellar: :any_skip_relocation, monterey:       "4b2f1d59d2b569259b42ea467321e9556c0686f2cfa879887eb117c2b992d28d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a8f9df4d9bf17701617e66e4bb82b6e7c6c335a70a4c9e9273db80114f00e66"
    sha256 cellar: :any_skip_relocation, catalina:       "31e4400a963d7bb3380d82c08f0f6f018250217ca0e5e4af36548242a67be401"
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
