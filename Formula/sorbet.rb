class Sorbet < Formula
  desc "Fast, powerful type checker designed for Ruby"
  homepage "https://sorbet.org"
  url "https://github.com/sorbet/sorbet/archive/0.4.5059.20191122150919-e82c71a19.tar.gz"
  version "0.4.5059"
  sha256 "6f7921c4689ced005f2ee5cf82c6470a876f3b70d32161e6dacbb4bf2fa10c32"

  depends_on "autoconf" => :build
  depends_on "coreutils" => :build
  uses_from_macos "llvm" => :build
  depends_on "parallel" => :build
  depends_on :xcode => :build

  def install
    # 1. use the ./bazel script which installs a very specific bazel version and it loads the *.rc files
    # 2. jemalloc is not set because it does not build on all platforms
    #    specifically on Mojave since it builds with Bazel, it does not get the correct header paths for the SDK.
    #    the headers are searched only /usr/include which have been removed in Mojave to a different path
    system "./bazel", "build", "--define=release=true", "--compilation_mode=opt", "--config=debugsymbols",
           "--config=static-libs", "--config=versioned", "--verbose_failures", "//main:sorbet"
    bin.install "bazel-bin/main/sorbet" => "sorbet"
  end

  test do
    assert_equal "", shell_output("#{bin}/sorbet -e '1 + 1'").chomp
  end
end
