class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.6.0.tar.gz"
  sha256 "fa41a5ef847fcb86ce9f2a9837adc9d80ba99839519d230115f2b00ff7a64156"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e3949ab0f18bbd183515aeb4ba39650a649be13d701bbe7e2177b1027157ea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dbf2b15ae5c76d41b6b452b1d95c60d677231513381b911dc60bccdeb50cfe8"
    sha256 cellar: :any_skip_relocation, monterey:       "237bae1a1bf9316fd53e14aba8f9d71a80e957312507581ea59ffa7f933a84e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f25e0cc1a86cdca52dde602529d55cec9e037316c87a5d9afad0df2d8f15d47a"
    sha256                               x86_64_linux:   "4bb7162fa3623f05588517413e2af189bc29dd1c9ffa05134bc4300b4c2a6e38"
  end

  depends_on xcode: "11.4"

  uses_from_macos "swift", since: :big_sur

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", \
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system "vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
