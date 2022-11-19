class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  url "https://github.com/PaulStoffregen/teensy_loader_cli/archive/2.2.tar.gz"
  sha256 "103c691f412d04906c4f46038c234d3e5f78322c1b78ded102df9f900724cd54"
  license "GPL-3.0-only"
  head "https://github.com/PaulStoffregen/teensy_loader_cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97148c203288820eb1f651a744f6bd0867b38383671ec7b7d0961504ecfc51ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a534e52c0de21164168c188ae60e929a17e183be3eba10ee7f4a1394c6bb94c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06529ad4373a483829c4b7ffd9bcb262077e7242be60c4a8645601ccc4aea134"
    sha256 cellar: :any_skip_relocation, ventura:        "ea14a1fe61e74119a04a43a5fb0b66c2860863e7f380471679b2750794d3bde6"
    sha256 cellar: :any_skip_relocation, monterey:       "0239cc41b148dea13c918f858930cca2631db5547e5aa17db57c9c5efdcdd2fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "1077e947102d333896796ada9f702fb11bfc43741b0ffe737292479624249ced"
    sha256 cellar: :any_skip_relocation, catalina:       "5f622de032367bbd7d3325e1e3d88ee205f941908a111102cbb10d176474e197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e61b76878c12cea8fbce6abbfcd7c2e26afbf79785fda38135009ae1d08f1f"
  end

  on_linux do
    depends_on "libusb-compat"
  end

  def install
    if OS.mac?
      ENV["OS"] = "MACOSX"
      ENV["SDK"] = MacOS.sdk_path || "/"

      # Work around "Error opening HID Manager" by disabling HID Manager check. Port of alswl's fix.
      # Ref: https://github.com/alswl/teensy_loader_cli/commit/9c16bb0add3ba847df5509328ad6bd5bc09d9ecd
      # Ref: https://forum.pjrc.com/threads/36546-teensy_loader_cli-on-OSX-quot-Error-opening-HID-Manager-quot
      inreplace "teensy_loader_cli.c", /ret != kIOReturnSuccess/, "0"
    end

    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    output = shell_output("#{bin}/teensy_loader_cli 2>&1", 1)
    assert_match "Filename must be specified", output
  end
end
