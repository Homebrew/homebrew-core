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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89e049e161c26f772a1332535973303a4024d86a2eb842137a7997ea3c2095cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc1daf32cf443a820331140f174c90d70b3ec70bf5637a6596b2f76a3d358406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1293ba965e67c483fdbe9f49191fa067f6b9d4a953f88ec0cfbb5fbf0f7d2fcd"
    sha256 cellar: :any_skip_relocation, tahoe:         "dfd63ab0138bc4f1152353d42c22560ff82b5d08507548561d704826da7c3486"
    sha256 cellar: :any_skip_relocation, sequoia:       "9c4c874eb2b6ae5e502bf32b8e8d1b2d8a7d900e84137aa45d2de1b48843d885"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c9f24586e47860089d4d1013160d43998f2f8efbbc5fb72a05caec9385508f7"
    sha256                               arm64_linux:   "213996c337e36dd8a46bb649963f6eea48b34b06f18ebaa06a7757f710f6b09d"
    sha256                               x86_64_linux:  "76f93a51750f1105f4c0c7dbcad5b33b754becbc02f0ca6a00b90c131a5509c8"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  on_sonoma :or_older do
    depends_on xcode: ["15.0", :build]
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
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
