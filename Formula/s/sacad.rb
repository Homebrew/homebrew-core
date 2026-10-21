class Sacad < Formula
  desc "Automatic cover art downloader"
  homepage "https://github.com/desbma/sacad"
  url "https://github.com/desbma/sacad/archive/refs/tags/3.0.3.tar.gz"
  sha256 "747a2b3847c85ad55f4b8ef53b9a133003c53ad9e3c644e74ed762756b613748"
  license "MPL-2.0"
  head "https://github.com/desbma/sacad.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c5b59f5701b5984a2f221d29ac801b892e8be69a25f9d4247459a82c49581b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b063668dc7680b1964e2aacbd7722a610878f4ab34f8aff5452cc60bae7d1df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a4d914c68d19da2954d07bc4a43f1d60ef10d54168cd8b00b0018906d5a7fcc"
    sha256 cellar: :any,                 arm64_linux:       "fa54c383e22d43539e0973e3a5698eb905356d307ddeea04988b7eda3750e785"
    sha256 cellar: :any,                 x86_64_linux:      "2d3a4ed945173cf6ca988fd75c3813791987124338d6a32b5013f7f5961943fd"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sacad --version")
    system bin/"sacad", "metallica", "master of puppets", "600", "AlbumArt.jpg"
  end
end
