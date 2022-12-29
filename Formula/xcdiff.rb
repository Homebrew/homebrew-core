class Xcdiff < Formula
  desc "Tool to diff xcodeproj files"
  homepage "https://github.com/bloomberg/xcdiff"
  url "https://github.com/bloomberg/xcdiff.git",
    tag:      "0.9.0",
    revision: "0e6a933af7cada626fb3aac2fe44c5dc8fb745c6"
  license "Apache-2.0"
  head "https://github.com/bloomberg/xcdiff.git", branch: "main"

  resource "homebrew-testdata" do
    url "https://github.com/bloomberg/xcdiff/archive/refs/tags/0.9.0.tar.gz"
    sha256 "f8565e0395a41274019ba691a9588e34f06ae586b921f43c0bd792981dcdb53a"
  end

  def install
    system "make", "update_version"
    system "make", "update_hash"
    system "make", "build"
    bin.install ".build/release/xcdiff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcdiff --version").chomp
    resource("homebrew-testdata").stage do
      assert_match "\n", shell_output(
        "#{bin}/xcdiff -p1 Fixtures/ios_project_1/Project.xcodeproj -p2 Fixtures/ios_project_1/Project.xcodeproj -d",
      )
      assert_match "✅ BUILD_PHASES > \"Project\" target\n", shell_output(
        "#{bin}/xcdiff " \
        "-p1 Fixtures/ios_project_1/Project.xcodeproj " \
        "-p2 Fixtures/ios_project_1/Project.xcodeproj " \
        "-g BUILD_PHASES " \
        "-t Project " \
        "-v",
      )
    end
  end
end
