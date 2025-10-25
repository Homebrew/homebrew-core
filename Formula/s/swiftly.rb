class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.1.0",
      revision: "30684f171da505160d20f7114c2b3def37a84b85"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c01353deda6280c28d9dd73318103b0be1510c82fc3e1a56096825a226d14f83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84528bf9c71d90cc9184435c9e1332dd8f29ea4e57f6dd797a345eaf41abb3c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfff8b834b89eea0088b290cf322c51f5d7bfe29c503086d950b432f1af7f704"
    sha256 cellar: :any_skip_relocation, sonoma:        "11492e3a951b58cb5d0bef241e2c067c067b3f735aef31b7655991e32f3e8185"
    sha256                               arm64_linux:   "bcbae6749404bc90aa941787724b0e692e771057d2187943ca6d6f59a35011de"
    sha256                               x86_64_linux:  "b4de198182d9cc32621761b50aabe01f56666d7ba873b8b659567e28a79f12e7"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "zlib"

  on_sonoma :or_older do
    depends_on xcode: ["15.0", :build]
  end

  on_linux do
    depends_on "libarchive"
  end

  def install
    args = %w[
      --configuration release
      --disable-sandbox
      --product swiftly
    ]
    if OS.linux?
      args += %W[
        --static-swift-stdlib
        -Xswiftc -I#{HOMEBREW_PREFIX}/include
        -Xlinker -L#{HOMEBREW_PREFIX}/lib
      ]
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["libarchive"].opt_lib
    end
    system "swift", "build", *args
    bin.install ".build/release/swiftly"
    generate_completions_from_executable(bin/"swiftly", "--generate-completion-script")
  end

  test do
    # Test swiftly with a private installation
    swiftly_bin = testpath/"swiftly"/"bin"
    mkdir_p swiftly_bin
    ENV["SWIFTLY_HOME_DIR"] = testpath/"swiftly"
    ENV["SWIFTLY_BIN_DIR"] = swiftly_bin
    ENV["SWIFTLY_TOOLCHAINS_DIR"] = testpath/"swiftly"/"toolchains"
    system bin/"swiftly", "init", "--assume-yes", "--no-modify-profile", "--skip-install"
  end
end
