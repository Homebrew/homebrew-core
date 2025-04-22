class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/refs/tags/19.1.1.tar.gz"
  sha256 "59e51d3e1d046b85fe664da7fea28e65996e200b5bac906203788dc17d4301d6"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "702d70ded6b2c22677204cedbfa5346421b2943753e5a28e625a1790f47cabcf"
    sha256 cellar: :any,                 arm64_sonoma:  "2c0259ab78e9880a59db090f0be164e248992722a370492f5fd7fc361e0c7069"
    sha256 cellar: :any,                 arm64_ventura: "7912d37527169a5b38fc117eca3d478def1c3434e1963d8b99d841d61e4aef05"
    sha256 cellar: :any,                 sonoma:        "8fa0660d40e6a186204bb8d5075db073087043e198af164e6821c654fc6ed8a4"
    sha256 cellar: :any,                 ventura:       "824bc70bd9ba27f645a011ed37841ce2fa307dc2b126c5115f43a840fafdfd8b"
    sha256                               arm64_linux:   "10e1b470daefac9fbe28cf49959c2a1e41f10bc294ced177a4fe327c913c10e3"
    sha256                               x86_64_linux:  "ee157b7f048c6a876bfc94f242b56cdf6139f16ee30fe34fd8fc548f70dd58e3"
  end

  uses_from_macos "swift", since: :sequoia # Swift 6.0

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "-Xswiftc", "-cross-module-optimization"
    bin.install ".build/release/vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_path_exists testpath/"hello-world/Package.swift"
  end
end
