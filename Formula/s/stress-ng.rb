class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.21.03.tar.gz"
  sha256 "6db7089ad9cc2c13d0aa1cf8755112adac92858f4582a46c765bb6b7e1c3e1af"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4be3bbc995cb5d93aaa7a8092e78ecd1391accc39e99c7f1fad4e8be57ac3b5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f0bfc6f295bd3f31ef3a68babef58a69bca6a64c8b4ac95ba951d7cf9b7423"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adb4f5505c702bfc911796b6dd50dfc348de43a490f692b96539c9fd92dd2197"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c4b3f0965adf6a5e9564f83f200235d8a603a0ba7afda21de0e8780ab0f796"
    sha256 cellar: :any,                 arm64_linux:   "a67ca32a55026224e230a3156b75bf5aae440e85695b5dae79bff66eee8c32c5"
    sha256 cellar: :any,                 x86_64_linux:  "ce1e49878810f8c52f09c5434b2d00fd78548040fa90fdc68fdacfb8c8cc75a1"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
