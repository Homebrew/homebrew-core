class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.2.20250521-115337+25ed6ac4.tar.gz"
  version "0.2.20250521-115337-25ed6ac4"
  sha256 "53c48bb807a7c65965a9f9f154f955ec4ccbce6696f721db73d0873e4bf03244"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "24e16f80032864b4adbf096223be034983f97f336a2dd3245d93f7d1e343faf9"
    sha256 cellar: :any,                 arm64_sequoia: "0004df8241dc01b6ddd1299a1f75f0288698042e065aba3fdee99e2f7b965918"
    sha256 cellar: :any,                 arm64_sonoma:  "f5a79d8a8861fa0a7a24e81108cf95b098f1eecaed22551804629ddae1b810fc"
    sha256 cellar: :any,                 sonoma:        "ab1e3160fb134a87be5d5268a11981051375cc9cd36f6719ab7714d34165acbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6937e7736547bac6bc35ea0f75e2a47ff792457af39f1819686615e97af81c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c50272688a28355e8d36757f857219e08a767cf6c51848040e91f4320485fd"
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
  depends_on "python@3.12" # Python 3.13 issue: https://github.com/facebook/sapling/issues/980

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

    python3 = "python3.12"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["PYTHON_SYS_EXECUTABLE"] = which(python3)
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
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    dylibs << (Formula["curl"].opt_lib/shared_library("libcurl")) if OS.linux?

    dylibs.each do |library|
      assert Utils.binary_linked_to_library?(bin/"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
