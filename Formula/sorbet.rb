class Sorbet < Formula
  desc "Fast, powerful type checker designed for Ruby"
  homepage "https://sorbet.org"
  url "https://github.com/sorbet/sorbet/archive/0.4.5085.20191130175112-e9dddf67d.tar.gz"
  version "0.4.5085"
  sha256 "79d73af69ac393db244c62b3847a496669a4dbd9c9b1c3fcf55d9d2be382aec5"

  depends_on "autoconf" => :build
  depends_on "bazel" => :build
  depends_on "coreutils" => :build
  uses_from_macos "llvm" => :build
  depends_on "parallel" => :build
  depends_on :xcode => :build

  def install
    # 1. use the bazel homebrew dependency not the bazel script file local
    # 2. jemalloc is not set because it does not build on all platforms
    #    specifically on Mojave since it builds with Bazel, it does not get the correct header paths for the SDK.
    #    the headers are searched only /usr/include which have been removed in Mojave to a different path
    # 3. D_LIBCPP_DISABLE_AVAILABILITY is to make it build on older compilers https://github.com/sorbet/sorbet/issues/1281#issuecomment-511543604
    system "#{Formula["bazel"].opt_bin}/bazel", "build", "--define=release=true", "--compilation_mode=opt", "--copt=-D_LIBCPP_DISABLE_AVAILABILITY",
           "--config=static-libs", "--config=versioned", "--verbose_failures", "//main:sorbet"
    bin.install "bazel-bin/main/sorbet" => "sorbet"
  end

  test do
    assert_equal "", shell_output("#{bin}/sorbet -e '1 + 1'").chomp
  end
end
