class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20240219-172743+3e819974.tar.gz"
  version "0.2.20240219-172743-3e819974"
  sha256 "3c0ff8e5daf795eb32f31c889b2908b90b302d93906d587e1f5665a8094d1c7b"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b9c52ae38949665729a6d9492d9c7f5310539b8ce9d24c721b0dafbbdb8359dd"
    sha256 cellar: :any,                 arm64_ventura:  "de5ea5fd11bee1fcdc2db58cc64c4fcd85de304c40e12173721e8395ff4e76e8"
    sha256 cellar: :any,                 arm64_monterey: "6911381dce5226cc2e670fb693752e38480d4d566a0d85987f810d5be1696de7"
    sha256 cellar: :any,                 sonoma:         "a67b69bfdf2a0dee32d96ab28766ef3fca4bdd4e7e7336e157f4e82f2be3dd6e"
    sha256 cellar: :any,                 ventura:        "f38e331e44464ad7febdf96e61210c18539839c2d55ced05073c542584a86654"
    sha256 cellar: :any,                 monterey:       "0fe97932b29c611621a064166a724774fee5120c02a6564ab329c186ed200282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dde3dabb2cc3d38010cd5327eaa06d1698d9237ddbac47a1b5a29371451c4b1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build # for `curl-sys` crate to find `curl`
  end

  # `setuptools` 66.0.0+ only supports PEP 440 conforming version strings.
  # Modify the version string to make `setuptools` happy.
  def modified_version
    # If installing through `brew install sapling --HEAD`, version will be HEAD-<hash>, which
    # still doesn't make `setuptools` happy. However, since installing through this method
    # will get a git repo, we can use the ci/tag-name.sh script for determining the version no.
    build_version = if version.to_s.start_with?("HEAD")
      Utils.safe_popen_read("ci/tag-name.sh").chomp + ".dev"
    else
      version
    end
    segments = build_version.to_s.split(/[-+]/)
    "#{segments.take(2).join("-")}+#{segments.last}"
  end

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

    python3 = "python3.11"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["SAPLING_VERSION"] = modified_version

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal("Sapling #{modified_version}", shell_output("#{bin}/sl --version").chomp)
    system "#{bin}/sl", "config", "--user", "ui.username", "Sapling <sapling@sapling-scm.com>"
    system "#{bin}/sl", "init", "--git", "foobarbaz"
    cd "foobarbaz" do
      touch "a"
      system "#{bin}/sl", "add"
      system "#{bin}/sl", "commit", "-m", "first"
      assert_equal("first", shell_output("#{bin}/sl log -l 1 -T {desc}").chomp)
    end

    [
      Formula["curl"].opt_lib/shared_library("libcurl"),
    ].each do |library|
      assert check_binary_linkage(bin/"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
