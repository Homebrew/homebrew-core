class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "ca236168b2ddee9e3fe056e0aa56fd961931e099919d2af250c23c73b8415f97"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebb8ccd6710967a053627bc18e4a4102681b1e80c9e47e7528c50a4248abe6c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01663e12d09adb69e474e81c6db36fe159706fee1a9bf3c80db1b1611cea92ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3de12e68efff5222bd23bd7ad3fbb1435d5c088917dd55010c4b958e6e47a8e4"
    sha256 cellar: :any_skip_relocation, ventura:        "883e85e7531d9e51564ddca542367a97f430173a072633cb68e903c20112f600"
    sha256 cellar: :any_skip_relocation, monterey:       "47bc7b9ab69be1471861ab473b546ad26960c9dc4bf19a4d793cc8cf28dce867"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cb828d74ac50d663112daa627c0c4e71576476e088a923d49b9f8616a82663f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c90cd39dc95219fcb61177a720c79ce3a769603372e9144eb846ac2e93d6629"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = fork do
      # sniffet is a GUI application
      exec bin/"sniffnet"
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
