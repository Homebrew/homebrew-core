class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/meta/sapling/archive/refs/tags/0.2.20261102-153821+a53273dc.tar.gz"
  sha256 "dc4a2a6a128e68af181f04916a6b8bc242c37a9e8a443ec644788131037c2b05"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_golden_gate: "49d475d60821550874721ff0d6ec14dfb5eccc1324f3c16c8a99c1e67d442548"
    sha256 arm64_tahoe:       "c57a16590dada8fa4ddfe0d48aec0731bbc20e42a0e9229ba24deca3118ea21f"
    sha256 arm64_sequoia:     "9d24566e77718b58cb0b3a94e9480c822a46d08ade090ee968a4444810a76b6a"
    sha256 arm64_linux:       "243d8c296ada2debb5a82d92cfd37b76149e12a1a875dc71ed782f201283f500"
    sha256 x86_64_linux:      "850a126ab60363148eb0445e3b60af92facfcab80529d2d70d12e584c0c0b3c5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "libssh2"
  depends_on "node"
  depends_on "openssl@4"
  depends_on "python@3.13" # remove from versioned_dependencies_conflicts_allowlist when using Python 3.14+

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "bzip2"
  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  uses_from_macos "curl", since: :sonoma

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "sl", because: "both install `sl` binaries"

  def watchman_rev
    watchman_repo = "https://github.com/facebook/watchman.git"
    max_date = version.patch.to_s.match(/^(\d{4})(\d{2})(\d{2})\b/).captures.join(".")
    tags = Utils.safe_popen_read("git", "ls-remote", "--sort=-version:refname", "--tags", watchman_repo)
    tags.scan(%r{^(\S+)\trefs/tags/v(\d{4}\.\d{2}\.\d{2})(?:\.\d+)+$}) do |rev, date|
      return rev if date <= max_date
    end
    odie "Unable to pick watchman tag based on sapling patch version #{version.patch}!"
  end

  def install
    # Workaround to improve reproducibility as Cargo.toml uses branch for some dependencies.
    # Actual reproducible builds won't be possible without a Cargo.lock.
    #
    # Related issue: https://github.com/facebook/sapling/issues/547
    if build.stable?
      github_hashes = buildpath.glob("build/deps/github_hashes/*/*-rev.txt").to_h do |revfile|
        commit = revfile.read[/commit ([0-9a-f]+)$/i, 1]
        odie "Unable to parse commit from #{revfile}!" if commit.nil?
        ["#{revfile.dirname.basename}/#{revfile.basename("-rev.txt")}", commit]
      end
      odie "Unable to find any revision files in build/deps/github_hashes!" if github_hashes.empty?

      # Watchman doesn't have a revision file. To avoid using HEAD, scan through tags
      # and use revision from tag created on or before date in Sapling patch version
      odie "Remove workaround for handling facebook/watchman!" if github_hashes.key?("facebook/watchman")
      github_hashes["facebook/watchman"] = watchman_rev

      no_modification = true
      Dir.glob("**/Cargo.toml") do |manifest|
        inreplace manifest do |s|
          github_hashes.each do |repo, rev|
            result = s.gsub! %r{(git = "https://github.com/#{repo}(?:\.git)?",) branch = "[^"]*"},
                             "\\1 rev = \"#{rev}\"",
                             audit_result: false
            no_modification &&= result.nil?
          end
        end
        if (git_branch = File.read(manifest)[/git = "[^"]*", branch = "[^"]*"/])
          odie "#{manifest} tracks a branch for #{git_branch}!"
        end
      end
      odie "Inreplace did not modify any branch usage in Cargo.toml manifests!" if no_modification
    end

    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    ENV["PYTHON_SYS_EXECUTABLE"] = ENV["PYO3_PYTHON"] = python3
    ENV["SAPLING_VERSION"] = if build.stable?
      version
    else
      Utils.safe_popen_read("ci/tag-name.sh").chomp + ".dev"
    end

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  test do
    require "utils/linkage"

    assert_equal "Sapling #{version}", shell_output("#{bin}/sl --version").chomp

    system bin/"sl", "config", "--user", "ui.username", "Sapling <sapling@sapling-scm.com>"
    system bin/"sl", "init", "--git", "foobarbaz"

    cd "foobarbaz" do
      touch "a"
      system bin/"sl", "add"
      system bin/"sl", "commit", "-m", "first"
      assert_equal "first", shell_output("#{bin}/sl log -l 1 -T {desc}").chomp
    end

    dylibs = [
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ]
    dylibs << (formula_opt_lib("curl")/shared_library("libcurl")) if OS.linux?

    dylibs.each do |library|
      assert Utils.binary_linked_to_library?(bin/"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
