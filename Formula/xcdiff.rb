class Xcdiff < Formula
  desc "Tool to diff xcodeproj files"
  homepage "https://github.com/bloomberg/xcdiff"
  url "https://github.com/bloomberg/xcdiff.git",
    tag:      "0.9.0",
    revision: "0e6a933af7cada626fb3aac2fe44c5dc8fb745c6"
  license "Apache-2.0"
  head "https://github.com/bloomberg/xcdiff.git", branch: "main"

  def install
    system "make", "update_version"
    system "make", "update_hash"
    system "make", "build"
    bin.install ".build/release/xcdiff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcdiff --version").chomp
  end
end
