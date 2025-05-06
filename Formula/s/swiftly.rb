class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.0.0",
      revision: "a9eecca341e6d5047c744a165bfe5bbf239987f5"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75aea1e89e30fd9a79bb0b85e40a495a000a701cd6c886e6d521fc6f04dc3a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e5b1fc6281e6008f944cac681007dd86280c49789299a0cb822efb64185d73e"
    sha256 cellar: :any,                 arm64_ventura: "2e68af78a8cdaaa0f30e692374e2f8f12d70d8badb54ba751661d30ebdff07e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c29010ed4b5be4cecdead4a32071a73efe827101eb3f1261194557fa290c4df4"
    sha256 cellar: :any,                 ventura:       "cfb17a9c3409df62c02b0422efddf79a568db0deab23034e2a4b6c38fe9cd8c6"
  end

  # On Linux, SPM can't find zlib installed by brew.
  # TODO: someone who cares: submit a PR to fix this!
  depends_on :macos

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "zlib"

  on_linux do
    depends_on "libarchive"
  end

  def install
    system "swift", "build", "--configuration", "release", "--product", "swiftly", "--disable-sandbox"
    bin.install ".build/release/swiftly"
  end

  test do
    swiftly_bin = testpath/"swiftly"/"bin"
    mkdir_p swiftly_bin
    ENV["SWIFTLY_HOME_DIR"] = testpath/"swiftly"
    ENV["SWIFTLY_BIN_DIR"] = swiftly_bin
    system bin/"swiftly", "init", "--assume-yes", "--no-modify-profile"
    system bin/"swiftly", "install", "latest", "--use"
    (testpath/"main.swift").write <<~EOS
      @main
      struct HelloSwiftly {
        static func main() {
          print("Hello Swiftly!")
        }
      }
    EOS
    system swiftly_bin/"swiftc", "main.swift", "-parse-as-library"
    assert_match "Hello Swiftly!", shell_output("./main").chomp
  end
end
