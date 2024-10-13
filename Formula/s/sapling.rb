class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20240718-145624+f4e9df48.tar.gz"
  version "0.2.20240718-145624-f4e9df48"
  sha256 "8081d405cddb9dc4eadd96f4c948b7686b0b61f641c068fc87b9c27518fb619e"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "13c25947c50793d1667376036bbe727ef7553644dc9e30da685fbe49bc41d903"
    sha256 cellar: :any,                 arm64_ventura:  "906fe8ad3aaa71ea843beabd59e547c30091376e04e24557550f8f378843e823"
    sha256 cellar: :any,                 arm64_monterey: "b9b45ea52f2afb75b4edef87552c04b9fa7987a8020fabecbc7c0818460bf282"
    sha256 cellar: :any,                 sonoma:         "8721faac713244b72b274d471d78a209af615459bae0f104bd9045281fb0ec35"
    sha256 cellar: :any,                 ventura:        "6062dce6be0a5eb76dd044b6d9d3aca7aabc25a31dae8e273bce2d6158888bda"
    sha256 cellar: :any,                 monterey:       "7bbaa4fee381fcc479a699622275335ccb6f07d8343718f6a8dd25ec956206f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0de217b8362da225c88e3c937f6c228e0597bc2dc6e1f88ca6520558c2becf"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build # for `curl-sys` crate to find `curl`
  end

  conflicts_with "sl", because: "both install `sl` binaries"

  def install
    if OS.mac?
      # Avoid vendored libcurl.
      inreplace %w[
        eden/scm/lib/http-client/Cargo.toml
        eden/scm/lib/doctor/network/Cargo.toml
        eden/scm/lib/revisionstore/Cargo.toml
      ],
        /^curl = { version = "(.+)", features = \["http2"\] }$/,
        'curl = { version = "\\1", features = ["http2", "force-system-lib-on-osx"] }'
    end

    python3 = "python3.12"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["PYTHON"] = ENV["PYTHON3"] = python3
    ENV["SAPLING_VERSION"] = if build.stable?
      version
    else
      Utils.safe_popen_read("ci/tag-name.sh").chomp + ".dev"
    end

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal "Sapling #{version}", shell_output("#{bin}/sl --version").chomp

    system bin/"sl", "config", "--user", "ui.username", "Sapling <sapling@sapling-scm.com>"
    system bin/"sl", "init", "--git", "foobarbaz"

    cd "foobarbaz" do
      touch "a"
      system bin/"sl", "add"
      system bin/"sl", "commit", "-m", "first"
      assert_equal "first", shell_output("#{bin}/sl log -l 1 -T {desc}").chomp
    end

    [
      Formula["curl"].opt_lib/shared_library("libcurl"),
    ].each do |library|
      assert check_binary_linkage(bin/"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
