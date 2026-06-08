class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.1.2",
      revision: "02c43bc590d6631411e3ada25faa20b1bd528bd8"
  license "Apache-2.0"
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8ebb74eb85f5b6d47f6f1824405e6a50e80b050ddbba59290b396155f7b422e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5282573b9939065fa12e60c76a1893a936c764275d2b5b422302811dd11ef3ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c204d69c5245c5bfb6d697fa588bbf76a9e1ea21a0393520de5f21bc5264f9c"
    sha256 cellar: :any_skip_relocation, tahoe:         "78bfe8723f6af24ed7a017abde7b536b941a990269a1fbe04fc263574232c7dd"
    sha256 cellar: :any_skip_relocation, sequoia:       "4df615c2451ff2728675d063a87373105986f62678ea558bdabec99141093af3"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ed5311d8e49cb1defdd05dd4db1cf2e3168ad92136e95ed2a91cd786fc57b1"
    sha256                               arm64_linux:   "3f7320d50b9bc92958d1243ab7a5eadcbc6aa66f8966f03084e020c21424e6ae"
    sha256                               x86_64_linux:  "890d2d187b31533324a0e8537825b5340e6df5c8d0ef4c908440d7282ce3265c"
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
