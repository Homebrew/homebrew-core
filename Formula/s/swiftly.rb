class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.0.0",
      revision: "a9eecca341e6d5047c744a165bfe5bbf239987f5"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77df84071ef43c8f4365c79c36723cf5db0581fd9e539609cf6a30dd2fd963db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c73ca2afd6e1e9f0c6ecee6f9730437c2ce9b09d7e5dcdecc387ef5b6e0c1b"
    sha256 cellar: :any,                 arm64_ventura: "f2a0ef49f2b9f8d444c36437390a2af05a90b12e5c330eca47946d3dfbb9c120"
    sha256 cellar: :any_skip_relocation, sonoma:        "87f9a8f5cc42d9d42316214d1311b46049effe1b577ed9c9a84d391d08f31892"
    sha256 cellar: :any,                 ventura:       "93f3e10f00be6a1bb295063045ff1fb78c5560e893bbc1cfbb3f3260812418c5"
    sha256                               x86_64_linux:  "d806e18a0d9e3efa67efe31f4cd6dcaca6a4bfa9b8ea1a7b3cc1b67fa21e0b7f"
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
    end
    system "swift", "build", *args

    bin.install ".build/release/swiftly"
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
