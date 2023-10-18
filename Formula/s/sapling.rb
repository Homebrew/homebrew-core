class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20230523-092610+f12b7eee.tar.gz"
  version "0.2.20230523-092610-f12b7eee"
  sha256 "57a04327052f900d95d0dd3800d8b13a411b08222307bb141109afca1d1d0eaf"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "46ef832a77d24f2b329fd5db6121cecc5a7adecd263523616f10a05c4b86bc5e"
    sha256 cellar: :any,                 arm64_ventura:  "e7eba951f6ab4b6c156696c2e213c59f36e66bcbc06cf70cb4e3ec034dc2d14d"
    sha256 cellar: :any,                 arm64_monterey: "294ee1972306ada79023dcc819b1aa20d88d3dc233f9c86810aa9d0f29e5231f"
    sha256 cellar: :any,                 sonoma:         "24a477053e6751ef017521e674ee271cd726951de9a7b82351155851b5d82084"
    sha256 cellar: :any,                 ventura:        "be5a01f25f0c72f1262b8ad58b0e4fcfba226b8ff0abbcd4d016d89898b0d5e8"
    sha256 cellar: :any,                 monterey:       "f9b28b788a775f1f04a91eb3a3a7d1bc5e00f61f35a2dec8b214ca48f41ccfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8180631c6928a00ddb1727341c374252e6298fea74969a33d4617e4c61f323b"
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
