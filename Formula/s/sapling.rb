class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  stable do
    url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20260522-084851+1e764c94.tar.gz"
    sha256 "2b2d3023ec10478e3d9d4db3240b71bc4068a63dd11f98f11d399372c62a5f9a"

    # Backport commit for Python 3.13
    patch do
      url "https://github.com/facebook/sapling/commit/3b640b74fe351c80d60954c8ea611d4b354187a4.patch?full_index=1"
      sha256 "4d85e880b1455ebde41d0419f952572e6a71ddb772f4ea594e9abaf80802b4e6"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9294201a8dec757bf5bd55c4a44376894363228b81024a5b3e4717455ad2fe52"
    sha256 arm64_sequoia: "9e6fdbb40e7ec40cc405cfcec3c719203f0db744cba29e46463241a4c8963d5f"
    sha256 arm64_sonoma:  "fc7e4f14c5849c393080bc3b9a7b5c33be2c37ad5e8bda36cb49465cbc6b4cc4"
    sha256 sonoma:        "10738cb4a907d8364db3ade320f3bc7cbe92f95de2f2393c35f3ab80b37732f4"
    sha256 arm64_linux:   "3c421260021a090f145878201fca5eb7693508d19ee9b446fe24f70f762b7331"
    sha256 x86_64_linux:  "21e72a841ef9f852836eba10ba4a88a4a7ca074b7fd53585efd60eecf6efe4e3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "libssh2"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "python@3.13"

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

    python3 = "python3.13"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["PYTHON_SYS_EXECUTABLE"] = ENV["PYO3_PYTHON"] = which(python3)
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
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ]
    dylibs << (formula_opt_lib("curl")/shared_library("libcurl")) if OS.linux?

    dylibs.each do |library|
      assert Utils.binary_linked_to_library?(bin/"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
