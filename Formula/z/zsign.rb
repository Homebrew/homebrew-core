class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "5e1a24116ca6875d6786703a7fb129d6afde06822f6a859de47d44eff4ad7c05"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12b2d224e7818f1e9cec61c8589ceef5a94dff184e436d6df5c248fd454f701c"
    sha256 cellar: :any, arm64_sequoia: "676dfd4f47dd0f5df002132ab6c198fd8e0bc9b4f7e62826281ecfee93e797f3"
    sha256 cellar: :any, arm64_sonoma:  "e560920c28953b8458377db62405dd39da87eea3c23e940b2cb769180a5437c5"
    sha256 cellar: :any, sonoma:        "cf3cd0251d44d70a6b77f30c29825c9a8c0668dd2cc684cb7095a6d8ef5a8751"
    sha256 cellar: :any, arm64_linux:   "ee7716a954c9594a20073aa6ce62914fc903ff8b4c6a7f8755651579d4a74b10"
    sha256 cellar: :any, x86_64_linux:  "85a3ba87eda0d4c1acc63665c0d726e9092a204b18c8b56aae08f9a19978c133"
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
