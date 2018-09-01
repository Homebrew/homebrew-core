class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/incubator-openwhisk-cli/archive/0.9.0-incubating.tar.gz"
  version "0.9.0-incubating"
  sha256 "76ec64d1a505c88f7d13df898b07cdea7b13b9799747d432e0bde55f7dc2c8b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "01efb1cc64b33be3d77aa477638179d75b159be1d956f95a84d04b7586175214" => :mojave
    sha256 "3a0e83ba6602152b582acc334c71a7aaf375dcc46730bc66aad3212fd840a348" => :high_sierra
    sha256 "f80044426ee56b6e70bb9eb8f63c95772e3d60f9aa579572e17bbf168ea91eca" => :sierra
    sha256 "12b2a1282a36a66f9abc148dcc6dd93cce4e34e381088d0f3b519132776a43e8" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "govendor" => :build

  # Add govendor support. Remove both of these on next release.
  patch do
    url "https://github.com/apache/incubator-openwhisk-cli/pull/362.patch?full_index=1"
    sha256 "5f8dba945cc6684846f77a2c628ca295755b97231e5ae4a7d3d870e8a2933ad6"
  end

  patch do
    url "https://github.com/apache/incubator-openwhisk-cli/pull/363.patch?full_index=1"
    sha256 "eef2bc85a8a8581baba590284c47eee6c033e53e0e93d1a65608f9faad9ba0d2"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/apache/incubator-openwhisk-cli"
    dir.install buildpath.children
    cd dir do
      system "go-bindata", "-pkg", "wski18n", "-o",
                           "wski18n/i18n_resources.go", "wski18n/resources"
      system "govendor", "sync"

      system "go", "build", "-o", bin/"wsk"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
