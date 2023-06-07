class SwitchLanPlay < Formula
  desc "Make you and your friends play games like in a LAN"
  homepage "https://github.com/spacemeowx2/switch-lan-play"
  url "https://github.com/spacemeowx2/switch-lan-play.git",
      tag:      "v0.2.3",
      revision: "c0c663e3fdc95d6d6e8ab401caa2bfb5b5872e00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4caf1d51243835a1c8816372f07bce843840f38f0a8ceaad42dbd19c15fe9c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f119af26760223542641ba4596c31ae3b4418b6ed955a2d5198fdc15aa6d23d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae86854d36264397768367d7ce69466967e303b5047828a6720c6574101a24b8"
    sha256 cellar: :any_skip_relocation, ventura:        "a27b8f98ef87fb078982323e661eb8c2368cb21dac8263c9590e805a7cb84679"
    sha256 cellar: :any_skip_relocation, monterey:       "5913dc50feffc96b3c7a1a6e76df7f4701d6ec8051a3ce2c8cd67c73e10785a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "520620d6ae69e98a169edda5ed47b0ebb496a843eedacda867b1eb52b14c007e"
    sha256 cellar: :any_skip_relocation, catalina:       "caa1992416c8eae4c281af3166238bb2bf8104c1d91d7dc37a2abd8715712ccc"
    sha256 cellar: :any_skip_relocation, mojave:         "62da027220b8d01270c8459cec638744ed06eac2ec046ccff56729b7f126eacf"
    sha256 cellar: :any_skip_relocation, high_sierra:    "41a10e6d0ce45410763c4774afa4286a8c633ac60348c0d0963e33cbef855c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0575f08e99046febb1ff6e1c00f02ab5b1bfa3e4b944828d0c858339748989b"
  end

  depends_on "cmake" => :build

  uses_from_macos "libpcap"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lan-play --version")
    assert_match "1.", shell_output("#{bin}/lan-play --list-if")
  end
end
