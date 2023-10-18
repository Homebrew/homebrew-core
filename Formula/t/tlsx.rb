class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "549cc5433183913ba3d568e115d7d36f8a734ac5befa02d85bc864fc1f5a09b8"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64318749930c221b706baa445f7f4458bdba349df1f32e85f7f2d54f5e40de55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55e0ee4e0b769078b60aff832b0ba8d75ef5cfb70e6de6513dd1b79728e53f83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41c749969c4a775f841c6e262b67edbbec820603b569b8323ec45ac3d3c09eeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f55303beee323866dcf2632f63839c92e7f029061ba317fa5bb29ab265642c89"
    sha256 cellar: :any_skip_relocation, ventura:        "342dd15587972e76a924d308ef8e3ac7f8a024805bc93f14c869800702164a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "814ee87d679b880856628f3ab0baaee985332ffd6566f66b007bebfa25c8297e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b8021cd2250d60e2841a337ef49cae73e2d4496db26b8e71cd9cff892039d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
