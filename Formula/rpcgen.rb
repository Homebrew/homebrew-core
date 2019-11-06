class Rpcgen < Formula
  desc "Protocol Compiler"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/developer_cmds/developer_cmds-63.tar.gz"
  sha256 "d4bc4a4b1045377f814da08fba8b7bfcd515ef1faec12bbb694de7defe9a5c0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bff5b2c16c8f161b4828d4f1cd6fe7353b63cb12bec8f4646716199b7f2fb522" => :catalina
    sha256 "e4c588689133af91de553a2a586cdaaebe27fc49c274ae1e2c7c889dc836a327" => :mojave
    sha256 "53ca92eda3bb7eb7f81aa70794ca1b5c16deaba84fe7ad41aaca11f32ebb8988" => :high_sierra
    sha256 "0d3a08d255ccbb538b0e818155e079ff74c65965d6effd67fd74775b837bdddb" => :sierra
    sha256 "75acb2995dda96d42faf6a3f83b1b30c9d0a6502ac1b031f92567282a1c67f69" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on :xcode => ["7.3", :build]

  # Add support for parsing 'hyper' and 'quad' types, as per RFC4506.
  # https://github.com/openbsd/src/commit/26f19e833517620fd866d2ef3b1ea76ece6924c5
  # https://github.com/freebsd/freebsd/commit/15a1e09c3d41cb01afc70a2ea4d20c5a0d09348a
  # Reported to Apple 13 Dec 2016 rdar://29644450
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rpcgen/63.patch"
    sha256 "d687d74e1780ec512c6dacf5cb767650efa515a556106400294393f5f06cf1db"
  end

  def install
    xcodebuild "-project", "developer_cmds.xcodeproj",
               "-target", "rpcgen",
               "-configuration", "Release",
               "SYMROOT=build"
    bin.install "build/Release/rpcgen"
    man1.install "rpcgen/rpcgen.1"
  end

  test do
    assert_match "nettype", shell_output("#{bin}/rpcgen 2>&1", 1)
  end
end
