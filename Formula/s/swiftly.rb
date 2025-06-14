class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.0.1",
      revision: "c14ee6e9fc94988e04b164b457a3b4afa800f68c"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a84f3d6faf7a00e1e9e836b0bd16bea9ddb1e49005ab420499bdb2f8328060e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6ccee7ec1311078cb828331131f003237f0c136f85ca5167e86daf03d54301d"
    sha256 cellar: :any,                 arm64_ventura: "dd8a30f30d7a712bcefdbbc87c46d334e9d58f029fd2ef9087f5f90a56d69da7"
    sha256 cellar: :any_skip_relocation, sonoma:        "191b819cb5f9baec07adef449079cd55b7b6eeecd298eeb8ccad2694dd134d63"
    sha256 cellar: :any,                 ventura:       "b340ce4b7c4c4eea79250e94375b4f5459638dd330cb391ca053aec2df300bf2"
    sha256                               x86_64_linux:  "db1b6d3fe662fcb8279542b4f84b2d05b308566c24dd5d05c20169febbe7ef7c"
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
