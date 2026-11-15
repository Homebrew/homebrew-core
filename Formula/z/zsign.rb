class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "a18493f399208dde3293efd753642cdda05e0506c3b05270ad6eb893d0a061af"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "18ec5a9df3e4010e28dcab846759b35960abc7fb1ab171568b6f9b036d3d9579"
    sha256 cellar: :any, arm64_tahoe:       "0e779315821e2b7baa10144d8145393dbb0ec13ef248576d895322e2c08cb29f"
    sha256 cellar: :any, arm64_sequoia:     "cefcee73206f34c7b07f1c5943c06022f43d9c32fe6781445a3cf643f03427d4"
    sha256 cellar: :any, arm64_linux:       "b0366af68e249cdda4eead77ce69143fc999e957b5d073bfaa989b64f3b57708"
    sha256 cellar: :any, x86_64_linux:      "811d835b6a4ca12324404742edb8cf71c7aafbc24d1af8acc9bdf1cec8f4d19a"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    system "make", "-C", build_dir, "CXX=#{ENV.cxx}", "VERSION=#{version}", "SYSTEM_MINIZIP=ng"
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end
