class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.2.0",
      revision: "fd76e26fe8ab7b6d5947a5fe1c33a34b760d39d8"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a957527a4e394efe370298ce5de008a993d3cf5add51845eb362f1f6c97caee0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ffb024d7d864930141f5ee063ef01b93296fe6706a50f6c1d9d86f96b7a61cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9e181f4875aecf4d98e84baeac7a8ceb04d23d172a9ea2091008c77a72f1903"
    sha256                               arm64_linux:       "5367f110ff637f6a60a2553253d5ef7cdaf60fd14b2ae750b8712998d626642f"
    sha256                               x86_64_linux:      "a93b0b266576df9f80861859fbdb0647f63f2ec21d31abaa202faca924fb486c"
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
    args = %w[--product swiftly]
    args += %W[-Xswiftc -I#{HOMEBREW_PREFIX}/include] if OS.linux?

    system "swift", "build", *args, *std_swift_args
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
