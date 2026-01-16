class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.1.1",
      revision: "714cc4e057e214132ee892b5a1bc66c3de590a97"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b4b8592cccdcdc87ccc6444423569d5cc56e54932f42ce373d28f3367b1d6d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd932983c67c6f54e31365ca89abf6193e10a8e9e8bf07605ada99f13ce773e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d1658a4fafacc477489dd87ca87d4ea1abac2e64b1cd5fbe0d3b72613346b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4933dd9007c8635d3ba99f82c6bb8c2164284d5728189f3318b13888e5672d7"
    sha256                               arm64_linux:   "ef0ec9dcb6bfc565518d6c29be534005e02dde2c035245979a46388371e22ae9"
    sha256                               x86_64_linux:  "2f3168ca8e72139b9b3a8d38384621b0140f4ae932b263d8e291497d1a051ed3"
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
    swiftly_bin = testpath/"swiftly/bin"
    mkdir_p swiftly_bin
    ENV["SWIFTLY_HOME_DIR"] = testpath/"swiftly"
    ENV["SWIFTLY_BIN_DIR"] = swiftly_bin
    ENV["SWIFTLY_TOOLCHAINS_DIR"] = testpath/"swiftly/toolchains"
    system bin/"swiftly", "init", "--assume-yes", "--no-modify-profile", "--skip-install"
  end
end
