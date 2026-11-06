class Swiftly < Formula
  desc "Swift toolchain installer and manager"
  homepage "https://github.com/swiftlang/swiftly"
  url "https://github.com/swiftlang/swiftly.git",
      tag:      "1.2.0",
      revision: "fd76e26fe8ab7b6d5947a5fe1c33a34b760d39d8"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/swiftlang/swiftly.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09ece07976ecbceee230ad2471b0848d57ca98bbb4265539a175b838a4018636"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e09894c9e9173ccc97101c91b802f048abf1dd2fb66b7e3ab65868fc9f8e827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb782b765678c5403708142c483e2b270c41a4c18147682c9955b977b41b09f7"
    sha256                               arm64_linux:       "f980153090d9412e1855bcba30869670f72792faeec0ed385487a6457ca81806"
    sha256                               x86_64_linux:      "f26c4f4b61622dc2d7e6f78bc8e061aec62d1c290dbedf1e6f951e214d267d79"
  end

  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+

  on_sequoia :or_newer do
    depends_on xcode: ["26.0", :build]
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[--product swiftly]
    if OS.linux?
      # SwiftBuild bypasses Homebrew's linker shim, so pass library paths explicitly.
      args += %W[
        -Xswiftc -I#{HOMEBREW_PREFIX}/include
        -Xlinker -L#{formula_opt_lib("zlib-ng-compat")}
        -Xlinker -rpath -Xlinker #{HOMEBREW_PREFIX}/lib
      ]
    end

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
