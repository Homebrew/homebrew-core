class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "f1cc0d4ffdf4eba3f2848ded3c81a1d37b614f6a5219b3aa444f4e222bcbcff4"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "00c80077eb2bcbdbf91412c3eaa0c019a6d293f65a4eb62b025dc3e84850a6c1"
    sha256 cellar: :any, arm64_sequoia: "f8029400a71952ff80da2b0b7e14a70b0c358be2309d6d94bbe5351bb3ca07d0"
    sha256 cellar: :any, arm64_sonoma:  "71b77283f2fa25241b29ed68c8d0efcf48f97ef0e7b194e5ff8aa3091f02cea0"
    sha256 cellar: :any, sonoma:        "5b828ce52185582c53bd8633bae88666240ab939862cee349315572a4b65b314"
    sha256 cellar: :any, arm64_linux:   "335fc3c72c8a06c93a1158888dc75bb5ccc76635f8385efb351633abe487b054"
    sha256 cellar: :any, x86_64_linux:  "bf58bfee32de6440ddde2470617779977e308c3e33ed9a4fd7a7938cd11d1d5f"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@4"

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
