class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "65b4c64b96bfa3e6f6f98a595428212700455281a6993b5bf4c3b7b61a5bb2a5"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "51b700b8ea62fbcf9ae56fd893c75a87f121c5e814c343ce54673f59d008a526"
    sha256 cellar: :any, arm64_sequoia: "677efd5a5eee1df0bf31ec674153b59750c2cad7f5e8bec224b7204f59dadf63"
    sha256 cellar: :any, arm64_sonoma:  "07b3571f310398a55ee492ea1597e1d6134d3fa44244185c7b15a41a1b8c72f9"
    sha256 cellar: :any, sonoma:        "aa9996b76d0fb76e423d4bd86b1801de4c4a666fe5eb3503e74e1aa8fe6eb62a"
    sha256 cellar: :any, arm64_linux:   "e9f2b02243edff9f05333d8f012c7f26fcb9a9964179c720d74eb6585c5cbca4"
    sha256 cellar: :any, x86_64_linux:  "e5272b0e0afe888a8439e9a3b90bcf40268c15ab9d9f442aa258e28f36574566"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
