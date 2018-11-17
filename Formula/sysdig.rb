class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.24.1.tar.gz"
  sha256 "828f99338e9912bde68aa0d6ae3dffe8c20bca999cfcc2b81f45b79cb97dffa9"

  bottle do
    sha256 "a318f6cd56995ca43c6c0e8dacdb3ca52f0187a5f6fc3cf5150c2070cfb0a881" => :mojave
    sha256 "1a430f227c903f11bbf8e68c1e1e9873e04cb222dcccc5d6e0ccefa2d9703d12" => :high_sierra
    sha256 "99e73c69615e2765ef4c7eb95ab165a94596b9da183d4868731b6c21d93c5a40" => :sierra
    sha256 "8fbe2b71cbddf520cb1b1bb737d25dd34d669264ceee06b61687a6e48344d68e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    ENV.libcxx if MacOS.version < :mavericks

    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}",
                            "-DUSE_BUNDLED_DEPS=OFF",
                            *std_cmake_args
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
