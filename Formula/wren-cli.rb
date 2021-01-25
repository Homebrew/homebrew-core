class WrenCli < Formula
  desc "Simple REPL and CLI tool for running Wren scripts"
  homepage "https://github.com/wren-lang/wren-cli"
  url "https://github.com/wren-lang/wren-cli/archive/0.3.0.tar.gz"
  sha256 "a498d2ccb9a723e7163b4530efbaec389cc13e6baaf935e16cbd052a739b7265"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5304fb08746fd9b3a796adc0c0c15398153cca662d64047f9424e039d4b446f" => :big_sur
    sha256 "c3bfd34fe266901e7d729780778390e1e3f9d65f96f25473add41c4572f43979" => :arm64_big_sur
    sha256 "c7f9b2cc6e9913517f802d8ef0142484fd86cb2b972ceb670f1b791b65144937" => :catalina
    sha256 "9bf6170802498342b99b6fb167a6ff9254601e911b5c7c74605145985909e6ff" => :mojave
    sha256 "074f4d9634a9e8e7fc33cd302778116121874851aa854830d41e3b73ba50500b" => :high_sierra
  end

  def install
    system "make", "-C", "projects/make.mac"
    bin.install "bin/wren_cli"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/hello.wren", testpath
    assert_equal "Hello, world!\n", shell_output("#{bin}/wren_cli hello.wren")
  end
end
