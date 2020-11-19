class SdLocal < Formula
  desc "Screwdriver local mode"
  homepage "https://screwdriver.cd"
  url "https://github.com/screwdriver-cd/sd-local/archive/v1.0.13.tar.gz"
  sha256 "3721406af5aa387f9390963880775aa1da2dc303b8ea79208fd4618db648fe36"
  license "BSD-3-Clause"
  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/screwdriver-cd/sd-local/cmd.version=#{version}"
    bin.install "sd-local"
  end

  test do
    output = shell_output("#{bin}/sd-local version 2>&1")
    assert_match version.to_s, output
  end
end
