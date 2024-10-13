class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "2fdf4a46bed59595566a532f3bc30c758a892668a0409e7f5b54320d6235c68d"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "76b6131cde70f08b85e1a9c300bc3d0b9bd9aa4ef68fda288f6be15a72097a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "899ec8d2cbdee003aaaf48c44bec9c8ddf292027db7c9351175e7fa097421361"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fb848d9bb9f69030a44d87e47c405b6d9149bb2114bc7fd9b52f3324f34a307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe2d08ac1c24cd5428c658ab41e0f011b363a1f1c608750c3d81e635151d1e5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba270a761df567a4e6f72acc9479addc6f896082163f6387cf5cbf34d33b66be"
    sha256 cellar: :any_skip_relocation, ventura:        "e9692a8b5e124d27245f0bea51aaa99bdfb76dab6147b08d1be49a814569a4d2"
    sha256 cellar: :any_skip_relocation, monterey:       "f19ba71eb1721adddb9f1e7bf99cfa3b044f4a4356462bb9a78cdc6b08814bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "842ceebc51ae3d728164e2ac3aa278abf71121c71bbacc37375e785c90d6bb33"
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
