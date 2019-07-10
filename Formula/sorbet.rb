class Sorbet < Formula
  desc "Ruby type checker"
  homepage "https://sorbet.org"
  url "https://github.com/sorbet/sorbet/archive/0.4.4405.20190708170651-4215f5eec.tar.gz"
  version "0.4.4405"
  sha256 "64f039938eb7cf9be3fd07fce9b9cfa993af7ca782d609f81800e56fc6dc1961"

  depends_on "autoconf" => :build
  depends_on "bazel" => :build
  depends_on "coreutils" => :build
  depends_on "parallel" => :build
  depends_on :xcode => :build

  def install
    if MacOS.version < "10.14"
      odie "MacOS 10.14 is required to build Sorbet."
    end

    system "bazel", "build", "//main:sorbet", "--config=release-mac", "--verbose_failures"
    bin.install "bazel-bin/main/sorbet"
  end

  test do
    assert_equal "", shell_output("#{bin}/sorbet -e '1 + 1'").chomp
  end
end
