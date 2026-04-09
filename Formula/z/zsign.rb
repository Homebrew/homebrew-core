class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "eb78aa9039b00317ee43859764e60d359faa36e890d8e2f5afc02f1bad848d0e"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f86c88ba452f45a83f92afc01f25d4eda136a1b32771e2e62330026be1707736"
    sha256 cellar: :any,                 arm64_sequoia: "3d424d242199e6e0ffdc46ed8b374ad4971a97d67c97cbe1b47afacdbad29f3f"
    sha256 cellar: :any,                 arm64_sonoma:  "c45ea596385f58a3e2f5b4666746e00d7910ffa43aa7438d8a939682e26ad89c"
    sha256 cellar: :any,                 sonoma:        "160c8ae4e8f24cb7d257b087bc426eae73253a5302fc76fb765f5a2af0bd471c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfdb88f0c4f9a6f72e98042368a6d299bf98df1e9a9d94b1ef4231dc6d97634f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60012df8502a19725a427e230b416b4dfb1bce5339a1772b8ee86de4fdc7f4d"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@3"

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    system "make", "-C", build_dir, "CXX=#{ENV.cxx}"
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end
