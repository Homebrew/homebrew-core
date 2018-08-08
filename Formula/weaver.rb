class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.10.0.tar.gz"
  sha256 "93dee436fcb13e60d379393da2e7d734c44037d95e97f2917982351446c81c69"

  depends_on :xcode => ["9.0", :build]

  def install
    # libxml2 has to be included in ISYSTEM_PATH for building one of
    # dependencies. It didn't happen automatically before Xcode 9.3
    # so homebrew patched environment variable to get it work.
    # But since Xcode 9.3 includes it already, the build will fail
    # because of redefinition of libxml2 module.
    # It's a bug of homebrew but before it's fixed, it's easier
    # to provide in-place workaround for now.
    # Please remove this once homebrew is patched.
    # https://github.com/Homebrew/brew/pull/4147
    if OS::Mac::Xcode.version >= Version.new("9.3")
      old_isystem_paths = ENV["HOMEBREW_ISYSTEM_PATHS"]
      ENV["HOMEBREW_ISYSTEM_PATHS"] = old_isystem_paths.gsub("/usr/include/libxml2", "")
    end

    system "make", "install", "PREFIX=#{prefix}"

    ENV["HOMEBREW_ISYSTEM_PATHS"] = old_isystem_paths if defined? old_isystem_paths
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "--version"
  end
end
