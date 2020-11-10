class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.9.tar.gz"
  sha256 "db4d52b8dfa14961e5c42d040ef7dec8f45458f528eefdc1aa09ea303c8297d7"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git"

  livecheck do
    url "https://github.com/rancher/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "60e0aaf8dfdd598e252e517dad981638fee13ee09ed84a17db1f73fcc0127c77" => :catalina
    sha256 "0f2db3a62b98d2284041580c842c5962aca726c59bfab511303b179ecde27470" => :mojave
    sha256 "89587feedd470f4af2091f29369ab4a87c8b62e2d295ce50286faaee3dcc69f9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags",
           "-w -X main.VERSION=#{version}",
           "-trimpath", "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
