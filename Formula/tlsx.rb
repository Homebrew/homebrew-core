class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.7.tar.gz"
  sha256 "8a86cda1d91e8878b927a85634e704de2a433fbb2c353f38c7f6fa9f023b0964"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51727db52c0d72542a8b6b91d78b83878cefef0ed7417241f6bf9b86aad2732e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51727db52c0d72542a8b6b91d78b83878cefef0ed7417241f6bf9b86aad2732e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51727db52c0d72542a8b6b91d78b83878cefef0ed7417241f6bf9b86aad2732e"
    sha256 cellar: :any_skip_relocation, ventura:        "999c406c054c9470a1882198bfb86003fd7047d2c592fdcfa539ccdd181a8eef"
    sha256 cellar: :any_skip_relocation, monterey:       "2dcda4c7c44096fe30feac94fa3ae0e3016c1b54676c366d6073f2c8d7c5a399"
    sha256 cellar: :any_skip_relocation, big_sur:        "84cb46087ccc8422054ffedaa3f21f083c84b6087b2fa10356dae9401aac3cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8d22d7e6af28e3cc8a60e110172f4e9d487f73ed081a85739855df36c68c097"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
