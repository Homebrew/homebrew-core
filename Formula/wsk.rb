class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/1.1.0.tar.gz"
  sha256 "d2365117b7c9144ed088b0d6a08c789df1e532e212223dc550d78ce2e1a92ae4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c822fb24ed5c3739e5b0868150394bd8b605e69acee26dbb4435ee712f456a1" => :big_sur
    sha256 "92c89f9beb12d02a0e07d17cc547138ccb06268ab0a8c4f3c6b6fdd304f24877" => :arm64_big_sur
    sha256 "09b1a197c94b0cfa767e35b26e078d25b4c6935f2a77815ea3ff377a10edee72" => :catalina
    sha256 "826e4c9d04daf02229f311006f28387d25fc4f282fc9ca53c3fade638bcc6c7a" => :mojave
    sha256 "cac45056e30af6e9c6d53c0568ab05c865c9aa7206a1b08e4fcf1de4fa48c35f" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go-bindata", "-pkg", "wski18n", "-o",
                          "wski18n/i18n_resources.go", "wski18n/resources"

    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
