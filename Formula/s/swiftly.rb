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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "907ff24bc28075aa64a7a5394465b67e5530113c10afe74bb5497534e70ab39b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa31e4a6cf9d3e74d818de7d62f61b9bfe9a6e723302ac065d706a547532d33b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68e6aaf6c455da51ce5089fc449786ad979d3e68b2cb45167b04f2f6ca10b336"
    sha256 cellar: :any_skip_relocation, sonoma:        "93180c8b870449e6c10fdd68d33e04330861c75c8c55791cd8ed9978a0673707"
    sha256                               arm64_linux:   "7ccfaf3042ce39ebcedefe3768ec33b43d8c67369072e08450faa935d587e3d2"
    sha256                               x86_64_linux:  "71736be307ef8421e3df0329e199dcca073a35904b4dbef774b4946a03015790"
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
