class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.0.0",
      revision: "a9eecca341e6d5047c744a165bfe5bbf239987f5"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "zlib"

  on_linux do
    depends_on "libarchive"
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      %w[--static-swift-stdlib -Xcc -I#{HOMEBREW_PREFIX}/include -Xlinker -L#{HOMEBREW_PREFIX}/lib]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "swiftly"
    bin.install ".build/release/swiftly"
  end

  test do
    assert_match "#{bin}/swiftly init", shell_output("#{bin}/swiftly help 2>&1", 1).chomp
  end
end
