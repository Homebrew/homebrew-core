class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.1.3",
      revision: "8e759540b22a1d58e592da96b7c1de058c360a8f"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d58f5260ea47597dcd0dedb885538df6b96b4e1a54d55ff7ae8b0e988a92c5a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a531dc20b3ba718c037f3c6253c6d023278efa0d9788cb31b456c858712e2006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e4e765c65e0460d40d27848e7c7593d54ae2263993edf3dc106407b6d5eef70"
    sha256 cellar: :any_skip_relocation, tahoe:         "33ee936143c5cdcb0e82c6a4dcf0b85ce450d083d415240d5898b9702325e65a"
    sha256 cellar: :any_skip_relocation, sequoia:       "6679cf1df2de0f6ffaddaaea427d8ad0178ac0a855bc280c0b04417bf4aff016"
    sha256 cellar: :any_skip_relocation, sonoma:        "4397920617a5d54bb1cd921e200434191d24d823923bbed05406792bceb6d08a"
    sha256                               arm64_linux:   "e19674db3979350e7f63e9a4f8d203b675ac50644788e60343e7c4674928637c"
    sha256                               x86_64_linux:  "d0b771f75427955f9c7999313ed118bfb2b044838829d2abe0882cfca9e2f862"
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
      ENV.prepend_path "LD_LIBRARY_PATH", formula_opt_lib("libarchive")
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
